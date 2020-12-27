//
//  HelpView.swift
//  WeatherForecast
//
//  Created by Danila Shikulin on 27.12.2020.
//

import Foundation
import SwiftUI

struct HelpView: View {
    
    @ObservedObject var viewModel: HelpViewModel
    
    var body: some View {
        viewModel.url.map {
            WebView(url: $0)
                .padding()
        }
    }
}
