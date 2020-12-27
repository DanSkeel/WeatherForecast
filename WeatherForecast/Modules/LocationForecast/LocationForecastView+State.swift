//
//  LocationForecastView+State.swift
//  WeatherForecast
//
//  Created by Danila Shikulin on 21.12.2020.
//

import Foundation

extension LocationForecastView.BodyView {
    
    struct ViewState {
        var title: String
        var content: Content
    }
}

extension LocationForecastView.BodyView.ViewState {
        
    enum Content {
        case loading
        case success(Model)
        case failure(Error)
    }
}

extension LocationForecastView.BodyView.ViewState.Content {

    struct Model {
        let mainValue: String
        var measurements: [Measurement]
    }
}

extension LocationForecastView.BodyView.ViewState.Content.Model {
    
    enum Measurement {

        struct Vector {
            let title: String
            let value: String
            let directionImageSystemName: String
            let rotation: Double
        }
        
        case scalar(title: String, value: String)
        case vector(Vector)
    }
}
