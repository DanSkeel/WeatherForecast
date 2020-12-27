//
//  LocationListBuilder.swift
//  WeatherForecast
//
//  Created by Danila Shikulin on 20.12.2020.
//

import SwiftUI
import CoreLocation

final class LocationListBuilder {
    
    func build() -> some View {
        
        let viewModel = LocationListViewModel(model: .init(),
                                              detailViewBuilder: LocationForecastBuilder(),
                                              locationPickerBuiler: LocationPickerBuilder())
        
        return LocationListView(viewModel: viewModel,
                                helpView: AnyView(HelpBuilder().build()))
    }
}
