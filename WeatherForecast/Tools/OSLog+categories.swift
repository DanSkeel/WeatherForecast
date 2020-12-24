//
//  OSLog+categories.swift
//  WeatherForecast
//
//  Created by Danila Shikulin on 24.12.2020.
//

import Foundation

import os.log

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier ?? "com.danskeel.weather_forecast"

    static let network = OSLog(subsystem: subsystem, category: "network")
}
