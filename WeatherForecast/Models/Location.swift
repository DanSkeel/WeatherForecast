//
//  Location.swift
//  WeatherForecast
//
//  Created by Danila Shikulin on 20.12.2020.
//

import Foundation
import CoreLocation

struct Location: Identifiable {
    
    let id: AnyHashable = UUID()
    let coordinates: CLLocationCoordinate2D
    let name: String
}
