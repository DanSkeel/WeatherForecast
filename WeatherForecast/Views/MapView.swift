//
//  MapView.swift
//  WeatherForecast
//
//  Created by Danila Shikulin on 24.12.2020.
//

import Foundation
import SwiftUI
import MapKit
import OSLog

protocol MapAnnotating {}

struct MapMarker: MapAnnotating {

    let coordinate: CLLocationCoordinate2D
    let title: String?
}

struct MapView: UIViewRepresentable {
    
    @Binding var coordinateRegion: MKCoordinateRegion
    
    private var annotations: [MKPointAnnotation]
    private var onTapAction: ((CLLocationCoordinate2D) -> Void)?
    
    public init<Items, Annotation>(
        coordinateRegion: Binding<MKCoordinateRegion>,
        annotationItems: Items,
        annotationContent: @escaping (Items.Element) -> Annotation
    ) where Items: RandomAccessCollection,
            Annotation: MapAnnotating,
            Items.Element: Identifiable {
        
        _coordinateRegion = coordinateRegion
        annotations = Self.annotations(for: annotationItems,
                                       annotationContent: annotationContent)
    }
    
    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator(mapRegion: $coordinateRegion)
        coordinator.onTapAtCoordinateAction = onTapAction
        return coordinator
    }
    
    func makeUIView(context: Context) -> MKMapView {
        
        let coordinator = context.coordinator
        
        let mapView = MKMapView()
        mapView.delegate = coordinator
                
        let gestureRecognizer = UITapGestureRecognizer(target: coordinator, action: #selector(Coordinator.didTapOnMap(gestureRecognizer:)))
        mapView.addGestureRecognizer(gestureRecognizer)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.region = coordinateRegion
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotations(annotations)
    }
    
    func onTapAtCoordinate(_ action: @escaping (CLLocationCoordinate2D) -> Void) -> MapView {
        var view = self
        view.onTapAction = action
        return view
    }
}

private extension MapView {
    
    static func annotations<Items, Annotation>(
        for items: Items,
        annotationContent: @escaping (Items.Element) -> Annotation
    ) -> [MKPointAnnotation]
    where Items : RandomAccessCollection,
          Annotation : MapAnnotating,
          Items.Element : Identifiable {
        
        items.map(annotationContent).compactMap {
            if let marker = $0 as? MapMarker {
                let annotation = MKPointAnnotation()
                annotation.coordinate = marker.coordinate
                annotation.title = marker.title
                return annotation
            }
            return nil
        }
    }
}

// MARK: - Coordinator

extension MapView {
        
    class Coordinator: NSObject, MKMapViewDelegate {
        
        @Binding var mapRegion: MKCoordinateRegion
        var onTapAtCoordinateAction: ((CLLocationCoordinate2D) -> Void)?
        
        init(mapRegion: Binding<MKCoordinateRegion>) {
            _mapRegion = mapRegion
            super.init()
        }
        
        // MARK: MKMapViewDelegate
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
            view.markerTintColor = .black
            return view
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            mapRegion = mapView.region
        }
        
        // MARK: UITapGestureRecognizer
        
        @objc func didTapOnMap(gestureRecognizer: UITapGestureRecognizer) {
            guard let mapView = gestureRecognizer.view as? MKMapView else { return }
            
            let location = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
            onTapAtCoordinateAction?(coordinate)
        }
    }
}

// MARK: - Previews

struct MapView_Previews: PreviewProvider {
    
    struct Pin: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
    }
    
    static let moscowCoodinate: CLLocationCoordinate2D = .init(latitude: 55.7558, longitude: 37.6173)
    
    static var previews: some View {
        Preview()
    }
    
    struct Preview: View {
        
        @State var coordinateRegion: MKCoordinateRegion = .init(center: moscowCoodinate,
                                                                span: .init(latitudeDelta: 1,
                                                                            longitudeDelta: 1))
        @State var pinCoordinate: CLLocationCoordinate2D? = nil
        
        var body: some View {
            MapView(coordinateRegion: $coordinateRegion,
                    annotationItems: [ pinCoordinate.map { Pin(coordinate: $0) }].compactMap { $0 },
                    annotationContent: { pin in
                        MapMarker(coordinate: pin.coordinate, title: "Moscow")
                    })
                .onTapAtCoordinate {
                    pinCoordinate = $0
                }
                .edgesIgnoringSafeArea(.all)
        }
    }
}
