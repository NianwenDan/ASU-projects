//
//  ContentView.swift
//  lab7
//
//  Created by Nianwen Dan on 3/31/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var books: [City]
    @State private var showAddView = false
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(books) { book in
                    NavigationLink(destination: CityDetailView(city: book)){
                         CityCell(city: book)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Locations")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button("Add City") {
                        showAddView = true
                        
                    }
                    .sheet(isPresented: $showAddView) {
                        AddCityView()
                    }
                }
            }
            
        }
        detail: {
            Text("Select an item")
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(books[index])
            }
        }
    }
}

struct CityDetailView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State var city: City
    
    
    var body: some View {
        VStack {
            Spacer()
            if let selectedPhotoData = city.image,
            let uiImage = UIImage(data: selectedPhotoData) {
             Image(uiImage: uiImage)
                 .resizable()
                 .scaledToFill()
                 .frame(maxHeight: 200)
            }
            Spacer()
            Text(city.title)
                .font(.largeTitle)
            Text(city.desc)
        }
        .navigationTitle("City Details")
        
    }
}

struct CityCell: View {
    let city: City
    var body: some View {
        HStack {
            if let selectedPhotoData = city.image,
            let uiImage = UIImage(data: selectedPhotoData) {
             Image(uiImage: uiImage)
                 .resizable()
                 .frame(width: 50, height: 50)
            }
            Text(city.title)
                .font(.headline)
            Spacer()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: City.self, inMemory: true)
}
