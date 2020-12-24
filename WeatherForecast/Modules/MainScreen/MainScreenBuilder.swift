//
//  MainScreenBuilder.swift
//  WeatherForecast
//
//  Created by Danila Shikulin on 20.12.2020.
//

import SwiftUI

final class MainScreenBuilder {
    
    func build() -> some View {
        LocationListBuilder().build()
    }
}
