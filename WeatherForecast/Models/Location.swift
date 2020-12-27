//
//  Location.swift
//  WeatherForecast
//
//  Created by Danila Shikulin on 20.12.2020.
//

import Foundation
import CoreLocation

struct Location: Identifiable {
    
    let coordinate: Coordinate
    let name: String
    
    private(set) var id = UUID()
    
    init(coordinate: CLLocationCoordinate2D, name: String) {
        self.coordinate = .init(latitude: coordinate.latitude,
                                longitude: coordinate.longitude)
        self.name = name
    }
}

extension Location {
    struct Coordinate {
        var latitude: CLLocationDegrees
        var longitude: CLLocationDegrees
    }
}

extension Location.Coordinate: Codable {}
extension Location: Codable {}

