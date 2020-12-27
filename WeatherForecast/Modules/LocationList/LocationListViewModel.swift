//
//  LocationListViewModel.swift
//  WeatherForecast
//
//  Created by Danila Shikulin on 20.12.2020.
//

import Foundation
import Combine
import SwiftUI

final class LocationListViewModel: ObservableObject {
    
    typealias ViewState = LocationListView.BodyView.State
    
    let detailViewBuilder: LocationForecastBuilder
    let locationPickerBuiler: LocationPickerBuilder
    
    @Published var locationPickerViewModel: LocationPickerViewModel?
    @Published var isShowingHelp: Bool = false
    @Published private(set) var state: ViewState
    
    private let model: LocationListModel
    private var cancellables: Set<AnyCancellable> = []
    
    init(model: LocationListModel,
         detailViewBuilder: LocationForecastBuilder,
         locationPickerBuiler: LocationPickerBuilder) {
        
        self.model = model
        self.detailViewBuilder = detailViewBuilder
        self.locationPickerBuiler = locationPickerBuiler
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
    
    func addItem() {
        locationPickerViewModel = locationPickerBuiler.buildViewModel(didSelectLocation: { [weak self] in
            guard let self = self else { return }
            if let location = $0 {
                self.model.addLocation(location)
            }
            self.locationPickerViewModel = nil
        })
    }
    
    func helpAction() {
        isShowingHelp = true
    }
}

private extension LocationListViewModel {
    
    static func state(for locations: [Location]) -> ViewState {
        
        let items: ViewState.Items
        
        if locations.isEmpty {
            items = .empty("Add a city to see forecast using +")
        } else {
            items = .nonEmpty(locations.map(item))
        }
        
        return .init(title: "Locations", items: items)
    }
    
    static func item(for location: Location) -> ViewState.Item {
        .init(id: location.id, name: location.name)
    }
}
