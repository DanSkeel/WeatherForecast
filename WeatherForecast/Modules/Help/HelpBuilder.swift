//
//  HelpBuilder.swift
//  WeatherForecast
//
//  Created by Danila Shikulin on 27.12.2020.
//

import Foundation
import SwiftUI

final class HelpBuilder {
    
    func build() -> some View {
        HelpView(viewModel: HelpViewModel())
    }
}

