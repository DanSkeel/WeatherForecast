//
//  HelpViewModel.swift
//  WeatherForecast
//
//  Created by Danila Shikulin on 27.12.2020.
//

import Foundation

final class HelpViewModel: ObservableObject {

    let url = Bundle.main.url(forResource: "Help", withExtension: "html")
}


