//
//  LocationPickerBuilder.swift
//  WeatherForecast
//
//  Created by Danila Shikulin on 24.12.2020.
//

import Foundation
import SwiftUI

final class LocationPickerBuilder {
    
    func build(for viewModel: LocationPickerViewModel) -> some View {
        return LocationPickerView(viewModel: viewModel)
    }
    
    func buildViewModel(didSelectLocation: @escaping (Location?) -> Void) -> LocationPickerViewModel {
        LocationPickerViewModel(didSelectLocation: didSelectLocation)
    }
}
