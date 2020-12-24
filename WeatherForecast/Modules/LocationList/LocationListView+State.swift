//
//  LocationListView+State.swift
//  WeatherForecast
//
//  Created by Danila Shikulin on 20.12.2020.
//

import Foundation

extension LocationListView.Body {
    
    struct State {
        
        var title: String
        var items: Items
    }
}

extension LocationListView.Body.State {
    
    enum Items {
        case nonEmpty([Item])
    }
    
    struct Item: Identifiable {
        
        let id: AnyHashable
        let name: String
    }
}
