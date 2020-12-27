//
//  LocationListModel.swift
//  WeatherForecast
//
//  Created by Danila Shikulin on 20.12.2020.
//

import CoreLocation
import Foundation
import OSLog

final class LocationListModel {
            
    private static let locationsKey = "locationsKey"
    
    @Published var locations: [Location] {
        didSet {
            Self.saveLocations(locations)
        }
    }
    
    init() {
        locations = Self.savedLocations() ?? []
    }
    
    func location(at index: Int) -> Location {
        locations[index]
    }
    
    func deleteLocations(for indexSet: IndexSet) {
        locations.remove(atOffsets: indexSet)
    }
    
    func addLocation(_ location: Location) {
        locations.insert(location, at: 0)
    }
}

private extension LocationListModel {
    
    static func savedLocations() -> [Location]? {
        guard let data = UserDefaults.standard.data(forKey: Self.locationsKey) else { return nil }
        do {
            return try JSONDecoder().decode([Location].self, from: data)
        } catch {
            os_log("Failed to decode locations: %{public}@", log: .storage, type: .error, error.localizedDescription)
            return nil
        }
    }
    
    static func saveLocations(_ locations: [Location]) {
        do {
            let data = try JSONEncoder().encode(locations)
            UserDefaults.standard.setValue(data, forKey: Self.locationsKey)
        } catch {
            os_log("Failed to encode locations: %{public}@", log: .storage, type: .error, error.localizedDescription)
        }
    }
}
