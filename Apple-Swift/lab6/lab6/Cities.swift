//
//  Cities.swift
//  lab6
//
//  Created by Nianwen Dan on 3/19/24.
//

import Foundation
import MapKit


class Cities: ObservableObject {
    @Published var cities: [City] = []
    
    func addCity(name: String, description: String, picture: UIImage) {
        let city = City(name: name, description: description, picture: picture)
        // Geocode and update city's coordinate
        geocode(city: city) { updatedCity in
            DispatchQueue.main.async {
                self.cities.append(updatedCity)
            }
        }
    }

    func deleteCity(at offsets: IndexSet) {
        cities.remove(atOffsets: offsets)
    }

    private func geocode(city: City, completion: @escaping (City) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(city.name) { (placemarks, error) in
            guard let placemark = placemarks?.first, let location = placemark.location else {
                print("Geocoding error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            var updatedCity = city
            updatedCity.coordinate = location.coordinate
            completion(updatedCity)
        }
    }
}

struct MKPointOfInterest: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}
