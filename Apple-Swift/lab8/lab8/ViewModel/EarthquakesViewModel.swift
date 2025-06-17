//
//  EarthquakesViewModel.swift
//  lab8
//
//  Created by Nianwen Dan on 4/11/24.
//

import Foundation
import MapKit

class EarthquakesViewModel: ObservableObject {
    @Published var earthquakes: [Earthquake] = []

    func fetch(city: String) {
        geocode(city: city) { [weak self] coordinate, error in
            guard let self = self else { return }

            if let error = error {
                print("Failed to get coordinates: \(error.localizedDescription)")
                return
            }

            guard let coordinate = coordinate else {
                print("No coordinates available.")
                return
            }

            print("Coordinates of the city are: \(coordinate.latitude), \(coordinate.longitude)")

            let area = self.calculateCoor(lon: coordinate.longitude, lat: coordinate.latitude)
            let urlString = "http://api.geonames.org/earthquakesJSON?north=\(area.0)&south=\(area.1)&east=\(area.2)&west=\(area.3)&username=asu_dan2025"
            print(urlString)

            guard let url = URL(string: urlString) else {
                print("Invalid URL")
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error fetching data: \(error)")
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("Server error!")
                    return
                }

                guard let data = data else {
                    print("No data received")
                    return
                }

                do {
                    let apiResponse = try JSONDecoder().decode(EarthquakeResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.earthquakes = apiResponse.earthquakes
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            }
            task.resume()
        }
    }
    
    private func geocode(city: String, completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(city) { placemarks, error in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let location = placemarks?.first?.location else {
                completion(nil, NSError(domain: "GeocodeError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No location found."]))
                return
            }

            completion(location.coordinate, nil)
        }
    }

    private func calculateCoor(lon: Double, lat: Double) -> (Double, Double, Double, Double) {
        return (lat+10, lat-10, lon+10, lon-10)
    }
}
