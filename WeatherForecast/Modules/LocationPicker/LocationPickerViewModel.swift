//
//  LocationPickerViewModel.swift
//  WeatherForecast
//
//  Created by Danila Shikulin on 24.12.2020.
//

import Foundation
import Combine
import CoreLocation
import MapKit
import OSLog

final class LocationPickerViewModel: ObservableObject, Identifiable {
    
    typealias ViewState = LocationPickerView.BodyView.ViewState
    
    let id = UUID()
    let didSelectLocation: (Location?) -> Void
    @Published var state: ViewState
    
    private (set) var didTapCallToAction: (() -> Void)?
    
    private let locationManager = LocationManager()
    private var regionSubscription: AnyCancellable?
    
    init(didSelectLocation: @escaping (Location?) -> Void) {
        self.didSelectLocation = didSelectLocation
        state = .init(prompt: "Choose location",
                      map: .init(coordinateRegion: .init(.world),
                                 annotationItems: []))
        
        subscribeCoordinateRegion(to: locationManager.$userCoordinates.eraseToAnyPublisher())
        locationManager.requestLocation()
    }
    
    func didTapOnMap(at coodinate: CLLocationCoordinate2D) {
        dropPin(at: coodinate)
    }
    
    func dropPin(at coodinate: CLLocationCoordinate2D) {
        var state = self.state
        state.map.annotationItems = [.init(coordinate: coodinate, title: nil)]
        self.state = state
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(.init(latitude: coodinate.latitude,
                                              longitude: coodinate.longitude)) { [weak self] placemarks, error in
            
            guard let self = self else { return }
            guard let placemark = placemarks?.first else { return }
            
            var state = self.state
            guard let pin = state.map.annotationItems.first,
                  pin.coordinate == coodinate else {
                return
            }
            
            let title = placemark.locality ?? placemark.name
            state.map.annotationItems = [.init(coordinate: coodinate, title: title)]
            
            state.callToAction = .init(iconSystemName: "bookmark.fill", text: "Bookmark")
            self.didTapCallToAction = { [weak self] in self?.bookmarkSelectedLocation() }

            self.state = state
        }    }
    
    func dropPin() {
        dropPin(at: state.map.coordinateRegion.center)
    }
    
    func bookmarkSelectedLocation() {
        guard let pin = state.map.annotationItems.first,
              let name = pin.title else {
            return
        }
        didSelectLocation(.init(coordinate: pin.coordinate, name: name))
    }
}

private extension LocationPickerViewModel {
    
    func subscribeCoordinateRegion(to coordinate: AnyPublisher<CLLocationCoordinate2D?, Never>) {
        regionSubscription = coordinate
            .compactMap { [weak self] coodinate -> ViewState? in
                guard let self = self else { return nil }
                guard let coodinate = coodinate else { return nil }
                var state = self.state
                state.map.coordinateRegion = .init(center: coodinate,
                                                   span: .init(latitudeDelta: 1,
                                                               longitudeDelta: 1))
                state.callToAction = .init(iconSystemName: "mappin", text: "Drop Pin")
                self.didTapCallToAction = { [weak self] in self?.dropPin() }
                return state
            }
            .assignNoRetain(to: \.state, on: self)
    }
}


private class LocationManager: NSObject, CLLocationManagerDelegate {
    
    @Published var userCoordinates: CLLocationCoordinate2D? = nil
    
    private let locationManager: CLLocationManager
    
    override init() {
        
        locationManager = CLLocationManager()
        super.init()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userCoordinates = locations.last?.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        os_log("Location request failed: %{public}@", log: .coreLocation, type: .error, error.localizedDescription)
    }
}
