//
//  ContentView.swift
//  lab6
//
//  Created by Nianwen Dan on 3/19/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject var locations = Cities()
    @State var isShowAddNewPlace = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(locations.cities) { city in
                    NavigationLink(destination: LocationDetailView(city: city)) {
                        HStack {
                            // Placeholder for city image
                            Image(uiImage: city.picture)
                                .resizable()
                                .frame(width: 50, height: 50)
                            
                            VStack(alignment: .leading) {
                                Text(city.name).font(.headline)
                                Text(city.description).font(.subheadline)
                            }
                        }
                    }
                }
                .onDelete(perform: locations.deleteCity)
            }
            .navigationTitle("Favorite Places")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        // Test
                        //locations.addCity(name: "New York", description: "A nice place")
                        isShowAddNewPlace = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            }
            .sheet(isPresented: $isShowAddNewPlace) {
                AddPlaces(viewModel: locations, isShowAddNewPlace: $isShowAddNewPlace)
            }
        }
    }
}

#Preview {
    ContentView()
}
