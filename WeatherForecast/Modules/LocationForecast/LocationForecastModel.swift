//
//  LocationForecastModel.swift
//  WeatherForecast
//
//  Created by Danila Shikulin on 21.12.2020.
//

import Foundation
import Combine

final class LocationForecastModel {
    
    let location: Location
    
    let api: OpenWeatherAPI
    
    var locationTitle: String {
        return location.name
    }
    
    init(location: Location, api: OpenWeatherAPI) {
        self.location = location
        self.api = api
    }
    
    func forecastAnyPublisher() -> AnyPublisher<Forecast, Error> {
        api.weather(latitude: location.coordinates.latitude,
                    longitude: location.coordinates.longitude)
            .map { [api] response in
                Self.forecast(for: response, from: api)
            }
            .mapError { $0 as Error}
            .eraseToAnyPublisher()
    }
}

// MARK: - Private extension

extension LocationForecastModel {
    
    static func forecast(for response: OpenWeatherAPI.WeatherResponse,
                         from api: OpenWeatherAPI) -> Forecast {
        
        return .init(temperature: .init(value: response.main.temp,
                                        units: api.temperatureUnits),
                     humidity: response.main.humidity,
                     rainVolumes: rainVolumes(for: response, from: api),
                     wind: wind(for: response, from: api))
    }
    
    static func rainVolumes(for response: OpenWeatherAPI.WeatherResponse,
                            from api: OpenWeatherAPI) -> [Forecast.RainVolume]? {
        
        guard let rain = response.rain else { return nil }
        let units = api.rainVolumeUnits
        return [
            .init(value: rain.oneHour,
                  units: units,
                  period: .init(hour: 1)),
            
            rain.threeHours.map {
                .init(value: $0,
                      units: units,
                      period: .init(hour: 3))
            }
        ].compactMap { $0 }
    }
    
    static func wind(for response: OpenWeatherAPI.WeatherResponse,
                     from api: OpenWeatherAPI) -> Forecast.Wind? {
        
        guard let wind = response.wind else { return nil }
        
        return .init(speed: .init(value: wind.speed,
                                  units: api.windSpeedUnits),
                     directionDegres: wind.deg)
    }
}

// MARK: - Models

extension LocationForecastModel {
    
    struct Forecast {
        
        var temperature: Temperature
        var humidity: Double
        var rainVolumes: [RainVolume]?
        var wind: Wind?
    }
}

extension LocationForecastModel.Forecast {
    
    struct Temperature {
        let value: Double
        let units: Units.Temperature
    }
        
    struct RainVolume {
        let value: Double
        let units: Units.RainVolume
        let period: DateComponents
    }
    
    struct Wind {
        
        struct Speed {
            let value: Double
            let units: Units.WindSpeed
        }
        
        let speed: Speed
        let directionDegres: Double
    }
}
