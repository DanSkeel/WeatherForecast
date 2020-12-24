//
//  LocationForecastBuilder.swift
//  WeatherForecast
//
//  Created by Danila Shikulin on 20.12.2020.
//

import SwiftUI

final class LocationForecastBuilder {
    
    func build(for viewModel: LocationForecastViewModel) -> some View {
        return LocationForecastView(viewModel: viewModel)
    }
    
    func buildViewModel(for location: Location) -> LocationForecastViewModel {
        
        let api = OpenWeatherClient(networkClient: NetworkClient())
        
        return .init(model: LocationForecastModel(location: location, api: api))
    }
}
