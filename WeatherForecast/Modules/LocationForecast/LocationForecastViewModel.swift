//
//  LocationForecastViewModel.swift
//  WeatherForecast
//
//  Created by Danila Shikulin on 20.12.2020.
//

import Foundation
import Combine

final class LocationForecastViewModel: ObservableObject {
 
    typealias ViewState = LocationForecastView.Body.ViewState
    typealias Forecast = LocationForecastModel.Forecast
    
    @Published private(set) var state: ViewState
    
    private lazy var durationFormatter: DateComponentsFormatter = {
        let durationFormatter: DateComponentsFormatter = .init()
        durationFormatter.unitsStyle = .spellOut
        return durationFormatter
    }()
    private var cancellables: Set<AnyCancellable> = []
    
    init(model: LocationForecastModel) {
        
        self.state = .init(title: model.locationTitle, content: .loading)
        
        model.forecastAnyPublisher()
            .compactMap { [weak self] in
                guard let self = self else { return nil }
                var state = self.state
                state.content = .success(self.content(for: $0))
                return state
            }
            .catch { [weak self] error -> Just<ViewState?> in
                guard let self = self else { return Just(nil) }
                var state = self.state
                state.content = .failure(error)
                return Just(state)
            }
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .assignNoRetain(to: \.state, on: self)
            .store(in: &cancellables)
    }
}

private extension LocationForecastViewModel {
    
    func content(for forecast: Forecast) -> ViewState.Content.Model {
    
        let temperature = self.temperature(from: forecast)
        
        var measurements: [ViewState.Content.Model.Measurement] = [
            .scalar(title: "HUMIDITY", value: "\(forecast.humidity) %"),
        ]
        
        if let volumes = forecast.rainVolumes {
            measurements.append(contentsOf: volumes.map(rainVolumeMeasurement))
        }
        
        if let wind = forecast.wind {
            measurements.append(.vector(vector(for: wind)))
        }
        
        return .init(mainValue: temperature,
                     measurements: measurements)
    }
    
    func temperature(from forecast: Forecast) -> String {
        let temperature = "\(forecast.temperature.value)"
        switch forecast.temperature.units {
        case .celsius: return temperature + "° C"
        }
    }
    
    func rainVolumeMeasurement(from rainVolume: Forecast.RainVolume) -> ViewState.Content.Model.Measurement {
        let period = durationFormatter.string(from: rainVolume.period)
        let duration = period.map{ ", FOR \($0.uppercased())" } ?? ""
            
        return .scalar(title: "RAIN VOLUME" + duration,
                       value: "\(rainVolume.value) \(string(for: rainVolume.units))")
    }
    
    func string(for units: Units.RainVolume) -> String {
        switch units {
        case .millimetre: return "mm"
        }
    }
    
    func vector(for wind: Forecast.Wind) -> ViewState.Content.Model.Measurement.Vector {
        .init(title: "WIND",
              value: "\(wind.speed.value) \(string(for: wind.speed.units))",
              directionImageSystemName: "location.north.fill",
              rotation: wind.directionDegres + 180)  // Wind direction is reported by the direction from which it originates.
    }
    
    func string(for units: Units.WindSpeed) -> String {
        switch units {
        case .meterPerSec: return "m/s"
        }
    }
}
