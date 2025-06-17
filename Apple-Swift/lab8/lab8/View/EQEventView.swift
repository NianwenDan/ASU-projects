//
//  EQEventView.swift
//  lab8
//
//  Created by Nianwen Dan on 4/11/24.
//

import SwiftUI
import MapKit

struct EQEventView: View {
    @ObservedObject var viewModel: EarthquakesViewModel = EarthquakesViewModel()
    let cityName: String
    
    var body: some View {
        NavigationStack {
//            if viewModel.earthquakes.isEmpty {
//                VStack {
//                    Spacer()
//                    Text("No Data Found!")
//                    Spacer()
//                }
//            }
            List() {
                ForEach(viewModel.earthquakes, id: \.eqid) { earthquake in
                    NavigationLink {
                        LocationPreview(location: CLLocationCoordinate2D(latitude: earthquake.lat,
                                                                         longitude: earthquake.lng))
                    } label: {
                        EQEventCellView(eqid: earthquake.eqid,
                                        time: earthquake.datetime,
                                        depth: earthquake.depth,
                                        latitude: earthquake.lat,
                                        longitude: earthquake.lng)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Details")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            viewModel.fetch(city: cityName)
        }
    }
}

struct EQEventCellView: View {
    let eqid: String
    let time: String
    let depth: Double
    let latitude: Double
    let longitude: Double
    
    var body: some View {
        VStack(spacing: 5) {
            // Show Posts Title
            HStack {
                Text("Earthquake ID: \(eqid)")
                Spacer()
            }
            .font(.headline)
            .lineLimit(2)
            // Show Posts MetaData
            VStack(spacing: 3) {
                HStack {
                    Image(systemName: "clock.arrow.circlepath")
                    Text(time)
                    Spacer()
                }
                HStack {
                    Image(systemName: "location")
                    Text("\(String(format: "%.2f", latitude)), \(String(format: "%.2f", longitude))")
                    Spacer()
                }
                HStack {
//                    Image(systemName: "increase.quotelevel")
                    Text("Depth: \(String(format: "%.2f", depth))")
                    Spacer()
                }
            }
            .font(.footnote)
            .lineLimit(1)
            .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    EQEventView(cityName: "Los Angeles")
}
