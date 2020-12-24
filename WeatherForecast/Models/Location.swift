//
//  Location.swift
//  WeatherForecast
//
//  Created by Danila Shikulin on 20.12.2020.
//

import Foundation

struct Location: Identifiable {
    
    let id: AnyHashable = UUID()
    let coordinates: Coordinates
}

extension Location {
    
    struct Coordinates {
        var longitude: Double
        var latitude: Double
    }
}
