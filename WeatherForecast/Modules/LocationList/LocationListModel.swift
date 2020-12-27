//
//  LocationListModel.swift
//  WeatherForecast
//
//  Created by Danila Shikulin on 20.12.2020.
//

import CoreLocation
import Foundation

final class LocationListModel {
        
    @Published var locations: [Location] = []
    
    func location(at index: Int) -> Location {
        locations[index]
    }
    
    func deleteLocations(for indexSet: IndexSet) {
        locations.remove(atOffsets: indexSet)
    }
    
    func addLocation(_ location: Location) {
        locations.insert(location, at: 0)
    }
}
