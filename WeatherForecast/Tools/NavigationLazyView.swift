//
//  NavigationLazyView.swift
//  WeatherForecast
//
//  Created by Danila Shikulin on 20.12.2020.
//

import SwiftUI

struct NavigationLazyView<Content: View>: View {
    
    let build: () -> Content
    
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
