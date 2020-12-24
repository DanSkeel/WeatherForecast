//
//  NetworkClient.swift
//  WeatherForecast
//
//  Created by Danila Shikulin on 29.11.2020.
//

import Foundation
import Combine

protocol INetworkClient {
    
    func responseDatePublisher(for request: URLRequest) -> AnyPublisher<Data, NetworkClientError>
}

enum NetworkClientError: LocalizedError {
        
    case connection(URLError)
    case unsuccessfulStatusCode(Int)
    case unexpected(Error? = nil)
        
    var errorDescription: String? {
        switch self {
        case .connection: return "Connection error"
        case .unsuccessfulStatusCode: return "Server error"
        case .unexpected: return "Unexpected error"
        }
    }
    
    var failureReason: String? {
        switch self {
        case let .unsuccessfulStatusCode(code):
            return "status code: \(code)"
            
        case let .connection(error as Error?),
             let .unexpected(error):
            return error?.localizedDescription
        }
    }
}

class NetworkClient {
    
    private let urlSession: URLSession
        
    init() {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        
        urlSession = .init(configuration: config)
    }
}

extension NetworkClient: INetworkClient {
    
    func responseDatePublisher(for request: URLRequest) -> AnyPublisher<Data, NetworkClientError> {
        
        urlSession
            .dataTaskPublisher(for: request)
            .mapError { NetworkClientError.connection($0) }
            .tryMap() { result -> Data in
                
                guard let httpResponse = result.response as? HTTPURLResponse else {
                    throw NetworkClientError.unexpected()
                }
                
                let statusCode = httpResponse.statusCode
                
                guard 200..<300 ~= statusCode else {
                    throw NetworkClientError.unsuccessfulStatusCode(statusCode)
                }
                
                return result.data
            }
            .mapError {
                guard let error = $0 as? NetworkClientError else {
                    return NetworkClientError.unexpected($0)
                }
                return error
            }
            .eraseToAnyPublisher()
    }
}
