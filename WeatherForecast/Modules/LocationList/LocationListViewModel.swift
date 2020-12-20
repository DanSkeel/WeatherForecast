//
//  LocationListViewModel.swift
//  WeatherForecast
//
//  Created by Danila Shikulin on 20.12.2020.
//

import Foundation
import Combine

final class LocationListViewModel: ObservableObject {
    
    typealias ViewState = LocationListView.Body.State
    
    let detailViewBuilder: LocationForecastBuilder
    @Published private(set) var state: ViewState
    
    private let model: LocationListModel
    private var cancellables: Set<AnyCancellable> = []
    
    init(model: LocationListModel,
         detailViewBuilder: LocationForecastBuilder) {
        
        self.model = model
        self.detailViewBuilder = detailViewBuilder
        state = Self.state(for: model.locations)
        
        model.$locations
            .map { Self.state(for: $0)}
            .assignNoRetain(to: \.state, on: self)
            .store(in: &cancellables)
    }
    
    func deleteItems(for indexSet: IndexSet) {
        model.deleteLocations(for: indexSet)
    }
    
    func detailViewModel(at index: Int) -> LocationForecastViewModel? {
        detailViewBuilder.buildViewModel(for: model.location(at: index))
    }
}

private extension LocationListViewModel {
    
    static func state(for locations: [Location]) -> ViewState {
        .init(title: "Locations",
              items: .nonEmpty(locations.map(item)))
    }
    
    static func item(for location: Location) -> ViewState.Item {
        .init(id: location.id,
              name: "(\(location.coordinates.longitude), \(location.coordinates.latitude)")
    }
}
