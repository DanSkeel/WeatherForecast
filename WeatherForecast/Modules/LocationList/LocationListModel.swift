//
//  LocationListModel.swift
//  WeatherForecast
//
//  Created by Danila Shikulin on 20.12.2020.
//

import Foundation

final class LocationListModel {
    
    static let backbaseCoordinates: Location.Coordinates = .init(longitude: 4.9277875388774905,
                                                                 latitude: 52.37119422170798)
    
    @Published var locations: [Location]
    
    internal init(locations: [Location]) {
        self.locations = locations
    }

    func location(at index: Int) -> Location {
        locations[index]
    }
    
    func deleteLocations(for indexSet: IndexSet) {
        locations.remove(atOffsets: indexSet)
    }
}
