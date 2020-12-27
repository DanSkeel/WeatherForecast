//
//  LocationPickerView+State.swift
//  WeatherForecast
//
//  Created by Danila Shikulin on 24.12.2020.
//

import Foundation
import MapKit

extension LocationPickerView.BodyView {
    
    struct ViewState {
        
        var prompt: String
        var map: Map
        var callToAction: CallToAction?
    }
}

extension LocationPickerView.BodyView.ViewState {
    
    struct Map {
        var coordinateRegion: MKCoordinateRegion
        var annotationItems: [Pin]
    }
    
    struct CallToAction {
        let iconSystemName: String
        let text: String
    }
}

extension LocationPickerView.BodyView.ViewState.Map {
    
    struct Pin: Identifiable {
        
        let id = UUID()
        var coordinate: CLLocationCoordinate2D
        var title: String?
    }
}
