//
//  LocationForecastBuilder.swift
//  WeatherForecast
//
//  Created by Danila Shikulin on 20.12.2020.
//

import SwiftUI

final class LocationForecastBuilder {
    
    func build(for viewModel: LocationForecastViewModel) -> some View {
        #warning("Unimplemented")
        return LocationForecastView(viewModel: viewModel)
    }
    
    func buildViewModel(for location: Location) -> LocationForecastViewModel {
        #warning("Unimplemented")
        return .init()
    }
}
