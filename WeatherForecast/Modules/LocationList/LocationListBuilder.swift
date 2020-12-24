//
//  LocationListBuilder.swift
//  WeatherForecast
//
//  Created by Danila Shikulin on 20.12.2020.
//

import SwiftUI

final class LocationListBuilder {
    
    func build() -> some View {
        let backbaseCoordinates: Location.Coordinates = .init(longitude: 4.9277875388774905,
                                                                     latitude: 52.37119422170798)
        let gentCoordinates: Location.Coordinates = .init(longitude: 3.7159840, latitude: 51.0505571)
        

        let locations: [Location] = [
            .init(coordinates: backbaseCoordinates),
            .init(coordinates: gentCoordinates)
        ]
        
        let viewModel = LocationListViewModel(model: .init(locations: locations),
                                              detailViewBuilder: LocationForecastBuilder())
        
        return LocationListView(viewModel: viewModel)
    }
}
