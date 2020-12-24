//
//  OpenWeatherAPI.swift
//  WeatherForecast
//
//  Created by Danila Shikulin on 29.11.2020.
//

import Combine
import Foundation

// MARK: - Protocol

protocol OpenWeatherAPI {
    
    typealias Units = OpenWeatherAPIUnits
    typealias ConditionType = OpenWeatherAPIConditionType
    typealias APIError = OpenWeatherAPIError
    
    var unitsSystem: Units.System { get }
    var temperatureUnits: Units.Temperature { get }
    var windSpeedUnits: Units.WindSpeed { get }
    var rainVolumeUnits: Units.RainVolume { get }
    
    // MARK: Weather
    
    typealias WeatherResponse = OpenWeatherAPIWeatherResponse
    
    func weather(latitude: Double, longitude: Double) -> AnyPublisher<WeatherResponse, APIError>
}

// MARK: - Models

enum OpenWeatherAPIUnits {}
    
extension OpenWeatherAPIUnits {
    
    enum System: String {
        case metric
    }
    
    enum Temperature {
        case celsius
    }
    
    enum WindSpeed {
        case meterPerSec
    }
    
    enum RainVolume {
        case millimetre
    }
}

enum OpenWeatherAPIConditionType {
    case temperature
    case humidity
    case rain
    case wind
}

enum OpenWeatherAPIError {
    
    case network(NetworkClientError)
    case formingRequest(message: String)
    case decoding(Error)
    case unexpected(Error)
}

extension OpenWeatherAPIError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .network: return "Network error"
        case .formingRequest: return "Failed to form request"
        case .decoding: return "Decoding response error"
        case .unexpected: return "Unexpected error"
        }
    }
    
    var failureReason: String? {
        switch self {
        
        case let .formingRequest(message: message):
            return message
            
        case let .network(error as Error),
             let .unexpected(error):
            
            if let localizedError = error as? LocalizedError {
                return [localizedError.errorDescription, localizedError.failureReason]
                    .compactMap { $0 }
                    .joined(separator: "\n\n")
            }
            return error.localizedDescription
            
        case let .decoding(error):
            return String(describing: error)
        }
    }
}
