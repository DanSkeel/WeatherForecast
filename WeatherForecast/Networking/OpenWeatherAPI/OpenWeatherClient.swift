//
//  OpenWeatherClient.swift
//  WeatherForecast
//
//  Created by Danila Shikulin on 22.12.2020.
//

import Foundation
import Combine
import OSLog

class OpenWeatherClient: OpenWeatherAPI {
    
    typealias APIError = OpenWeatherAPI.APIError
    
    let networkClient: INetworkClient
        
    let baseURLString: String = "http://api.openweathermap.org/data/2.5"
    let appid: String = "c6e381d8c7ff98f0fee43775817cf6ad"
    
    var unitsSystem: Units.System = .metric
    var temperatureUnits: Units.Temperature = .celsius
    var windSpeedUnits: Units.WindSpeed = .meterPerSec
    var rainVolumeUnits: Units.RainVolume = .millimetre
    
    lazy var defaultParameters: [String: String] = [
        "units": unitsSystem.rawValue
    ]
        
    init(networkClient: INetworkClient) {
        self.networkClient = networkClient
    }
    
    func requestPublisher(urlPath: String,
                          parameters: [String: String]) -> AnyPublisher<URLRequest, APIError> {
        Just(())
            .tryMap {
                try makeRequest(urlPath: urlPath,
                                parameters: parameters)
            }
            .mapError { formingRequestError in
                guard let error = formingRequestError as? APIError else {
                    return APIError.unexpected(formingRequestError)
                }
                return error
            }
            .eraseToAnyPublisher()
    }
    
    static func responsePublisher<Response>(
        for request: URLRequest,
        with networkClient: INetworkClient,
        decoding responseType: Response.Type
    ) -> AnyPublisher<Response, APIError> where Response: Decodable {
        
        networkClient.responseDatePublisher(for: request)
            .mapError { APIError.network($0) }
            .handleEvents(receiveOutput: {
                let body = String(data: $0, encoding: .utf8) ?? "non decodable"
                os_log("Did load data: %{public}@", log: OSLog.network, type: .info, body)
            })
            .decode(type: Response.self, decoder: JSONDecoder())
            .mapError {
                guard let error = $0 as? APIError else {
                    return APIError.decoding($0)
                }
                return error
            }
            .eraseToAnyPublisher()
    }
}

private extension OpenWeatherClient {
    
    func makeRequest(urlPath: String,
                     parameters: [String: String]) throws -> URLRequest {
                
        guard var urlComponents = URLComponents(string: baseURLString) else {
            throw APIError.formingRequest(message: "Bad base URL: \(baseURLString)")
        }
        urlComponents.path += urlPath
        
        var queryItems = urlComponents.queryItems ?? []
        queryItems.append(.init(name: "appid", value: appid))
        parameters.forEach { queryItems.append(.init(name: $0, value: $1)) }
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            throw APIError.formingRequest(message: "Failed to form URL with path: \(urlPath) and parameters: \(queryItems)")
        }
                
        return URLRequest(url: url)
    }
}
