//
//  LocationForecastView.swift
//  WeatherForecast
//
//  Created by Danila Shikulin on 20.12.2020.
//

import SwiftUI

struct LocationForecastView: View {
    
    @ObservedObject var viewModel: LocationForecastViewModel
    
    var body: Body {
        Body(state: viewModel.state)
    }
}

extension LocationForecastView {
    
    struct Body: View {
        
        let state: ViewState
        
        var body: some View {
            content(for: state)
                .navigationBarTitle(state.title)
        }
    }
}

// MARK: - Body private methods

private extension LocationForecastView.Body {
    
    func content(for state: ViewState) -> some View {
        switch state.content {
        case .loading:
            return AnyView(ActivityIndicator())
        case let .success(model):
            return AnyView(successContent(for: model))
        case let .failure(error):
            return AnyView(ErrorView(error: error).padding())
        }
    }
    
    func successContent(for model: ViewState.Content.Model) -> some View {
        ScrollView {
            Text(model.mainValue)
                .font(.largeTitle)
                .padding(100)
            
            ForEach(Array(model.measurements.enumerated()), id: \.offset) { _, measurement in
                
                Divider()
                
                view(for: measurement)
            }
        }
    }
    
    func view(for measurement: ViewState.Content.Model.Measurement) -> some View {
        switch measurement {
        case let .scalar(title: title, value: value):
            return AnyView(Scalar(title: title, value: value))
        case let .vector(model):
            return AnyView(Vector(model: model))
        }
    }
}

// MARK: - Body subviews

private extension LocationForecastView.Body {
    
    struct Scalar: View {
        
        let title: String
        let value: String
        
        var body: some View {
            VStack {
                Text(title)
                    .font(.caption)
                
                Text(value)
                    .font(.title)
            }
        }
    }
    
    struct Vector: View {
        
        let model: ViewState.Content.Model.Measurement.Vector
        
        var body: some View {
            VStack {
                Text(model.title)
                    .font(.caption)
                
                HStack(spacing: 10) {
                    Text(model.value)
                        .font(.title)
                    
                    Image(systemName: model.directionImageSystemName)
                        .rotationEffect(.init(degrees: model.rotation))
                }
                
            }
        }
    }
}

// MARK: - Previews

struct LocationForecastView_Previews: PreviewProvider {
    
    typealias ViewState = LocationForecastView.Body.ViewState

    static var previews: some View {
        Group {
            ForEach(Array(contentModels.enumerated()), id: \.offset) { _, model in
                preview(for: .init(title: "Amsterdam", content: .success(model)))
            }
            
            preview(for: .init(title: "Amsterdam",
                               content: .failure(ErrorExample())))
        }
    }
    
    static func preview(for state: ViewState) -> some View {
        NavigationView {
            LocationForecastView.Body(state: state)
        }
    }
    
    static let contentModels: [ViewState.Content.Model] = [
        .init(mainValue: "39º C",
              measurements: [
                .scalar(title: "HUMIDITY",
                        value: "34%"),
                .vector(.init(title: "WIND",
                              value: "15 m/s",
                              directionImageSystemName: "location.north.fill",
                              rotation: 45))
              ])
        ]
    
    struct ErrorExample: LocalizedError {
        var errorDescription: String? = "Error Description"
        var failureReason: String? = "Failure Reason"
        var recoverySuggestion: String? = "Recovery Suggestion"
    }
}
