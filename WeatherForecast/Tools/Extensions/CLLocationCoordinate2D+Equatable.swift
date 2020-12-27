//
//  CLLocationCoordinate2D+Equatable.swift
//  WeatherForecast
//
//  Created by Danila Shikulin on 26.12.2020.
//

import CoreLocation

extension CLLocationCoordinate2D: Equatable {}

public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    let epsilone = CLLocationDegrees.leastNonzeroMagnitude
    return fabs(lhs.latitude - rhs.latitude) < epsilone &&
        fabs(lhs.longitude - rhs.longitude) < epsilone
}
