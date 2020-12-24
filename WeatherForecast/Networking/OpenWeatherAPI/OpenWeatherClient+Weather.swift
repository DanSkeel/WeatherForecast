//
//  OpenWeatherClient+Weather.swift
//  WeatherForecast
//
//  Created by Danila Shikulin on 22.12.2020.
//

import Foundation
import Combine

extension OpenWeatherClient {
    
    typealias WeatherResponse = OpenWeatherAPI.WeatherResponse
    
    func weather(latitude: Double, longitude: Double) -> AnyPublisher<WeatherResponse, APIError> {
        var parameters = defaultParameters
        parameters["lat"] = "\(latitude)"
        parameters["lon"] = "\(longitude)"
        
        return requestPublisher(urlPath: "/weather", parameters: parameters)
            .map { [networkClient] in
                Self.responsePublisher(for: $0, with: networkClient, decoding: WeatherResponse.self)
            }
            .switchToLatest()
            .eraseToAnyPublisher()
    }
}

// MARK: - Models

struct OpenWeatherAPIWeatherResponse {
    
    let main: Main
    let rain: Rain?
    let wind: Wind?
}

extension OpenWeatherAPIWeatherResponse {
    
    struct Main {
        let temp: Double
        let humidity: Double
    }
    
    struct Rain {
        
        /// Rain volume for the last 1 hour, mm
        let oneHour: Double
        
        /// Rain volume for the last 3 hours, mm
        let threeHours: Double?
    }
    
    struct Wind {
        
        /// Wind speed. Unit Default: meter/sec, Metric: meter/sec, Imperial: miles/hour.
        let speed: Double
        
        /// Wind direction, degrees (meteorological)
        let deg: Double
        
        /// Wind gust. Unit Default: meter/sec, Metric: meter/sec, Imperial: miles/hour
        let gust: Double?
    }
}

// MARK: - Decoding

extension OpenWeatherClient.WeatherResponse: Decodable {}
extension OpenWeatherClient.WeatherResponse.Main: Decodable {}
extension OpenWeatherClient.WeatherResponse.Wind: Decodable {}

extension OpenWeatherClient.WeatherResponse.Rain: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
        case threeHours = "3h"
    }
}

