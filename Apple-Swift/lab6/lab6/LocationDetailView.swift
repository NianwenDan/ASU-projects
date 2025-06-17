//
//  LocationDetailView.swift
//  lab6
//
//  Created by Nianwen Dan on 3/19/24.
//

import SwiftUI
import MapKit

struct LocationDetailView: View {
    @State private var searchQuery = ""
    @State private var pointsOfInterest: [MKPointOfInterest] = []
    var city: City
    
    var body: some View {
        
        @State var camera: MapCameraPosition = .region(MKCoordinateRegion(center: city.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000))
        
        let location = CLLocationCoordinate2D(
            latitude: city.coordinate.latitude,
            longitude: city.coordinate.longitude
            )
        
        TextField("Search (e.g., coffee, pizza, movie)", text: $searchQuery, onCommit: {
            searchInCity(cityName: city.name, query: searchQuery)
        })
        .padding()
        Map(position: $camera) {
            Marker(city.name, coordinate: location)
            ForEach(pointsOfInterest) { point in
                Marker(point.name, coordinate: point.coordinate)
            }
        }
        .safeAreaInset(edge: .bottom) {
            VStack {
                Text(city.name).font(.largeTitle)
                HStack {
                    Spacer()
                    Text("Latitude: \(city.coordinate.latitude)")
                    Text("Longitude: \(city.coordinate.longitude)")
                    Spacer()
                }
            }
            .padding(.top)
            .background(.thinMaterial)
        }
        .navigationTitle(city.name)
    }
    
    func searchInCity(cityName: String, query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = MKCoordinateRegion(center: city.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            self.pointsOfInterest = response.mapItems.map { item in
                MKPointOfInterest(name: item.name ?? "Unknown", coordinate: item.placemark.coordinate)
            }
        }
    }
}

#Preview {
    LocationDetailView(city: City(name: "Los Angeles",
                                  description: "Known for entertainment and beaches",
                                  coordinate: CLLocationCoordinate2D(
                                    latitude: 34.0522,
                                    longitude: -118.2437
                                  ),
                                  picture: UIImage(resource: .cityImagePlaceholder)
                                 )
    )
}
