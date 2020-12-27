//
//  LocationPickerView.swift
//  WeatherForecast
//
//  Created by Danila Shikulin on 24.12.2020.
//

import Foundation
import SwiftUI
import MapKit

struct LocationPickerView: View {
    
    @ObservedObject var viewModel: LocationPickerViewModel
    
    var body: BodyView {
                
        BodyView(state: viewModel.state,
                 didTapOnMapAction: viewModel.didTapOnMap,
                 didTapCallToAction: viewModel.didTapCallToAction,
                 coordinateRegion: $viewModel.state.map.coordinateRegion)
    }
}

extension LocationPickerView {
    
    struct BodyView: View {
        
        let state: ViewState
        let didTapOnMapAction: (CLLocationCoordinate2D) -> Void
        let didTapCallToAction: (() -> Void)?
        
        @Binding var coordinateRegion: MKCoordinateRegion
        
        var body: some View {
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    Text(state.prompt)
                        .font(.largeTitle)
                        .padding()
                    
                    MapView(coordinateRegion: $coordinateRegion,
                            annotationItems: state.map.annotationItems) {
                        MapMarker(coordinate: $0.coordinate, title: $0.title)
                    }
                    .onTapAtCoordinate(didTapOnMapAction)
                    .edgesIgnoringSafeArea(.all)
                }
                
                state.callToAction.map { item in
                    Button(action: { didTapCallToAction?() }) {
                        HStack {
                            Image(systemName: item.iconSystemName)
                            Text(item.text)
                        }
                        .font(.headline)
                        .foregroundColor(Color.white)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(15)
                    }
                }
            }
        }
    }
}

struct LocationPickerView_Previews: PreviewProvider {
    
    static let moscowCoodinate: CLLocationCoordinate2D = .init(latitude: 55.7558, longitude: 37.6173)
    
    static var previews: some View {
        LocationPickerView.BodyView(state: .init(prompt: "Choose city",
                                             map: .init(coordinateRegion: MKCoordinateRegion(.world),
                                                        annotationItems: [.init(coordinate: moscowCoodinate,
                                                                                title: "Moscow")]),
                                             callToAction: .init(iconSystemName: "mappin", text: "Drop Pin")),
                                didTapOnMapAction: {_ in},
                                didTapCallToAction: {},
                                coordinateRegion: .constant(.init()))
    }
}
