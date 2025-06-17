//
//  LocationPreview.swift
//  lab8
//
//  Created by Nianwen Dan on 4/12/24.
//

import SwiftUI
import MapKit

struct LocationPreview: View {
    let location: CLLocationCoordinate2D
    
    var body: some View {
        @State var camera: MapCameraPosition = .region(MKCoordinateRegion(center: location, latitudinalMeters: 1000000, longitudinalMeters: 1000000))
        
        Map(position: $camera) {
            Marker("", coordinate: location)
        }
        .navigationTitle("Map View")
    }
}

#Preview {
    LocationPreview(location: CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437))
}
