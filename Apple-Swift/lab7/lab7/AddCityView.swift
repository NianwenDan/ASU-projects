//
//  AddPlaces.swift
//  lab6
//
//  Created by Nianwen Dan on 3/19/24.
//

import SwiftUI
import PhotosUI
import SwiftData

struct AddCityView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Query private var cities: [City]
    
    @State private var title = ""
    @State private var desc = ""
    
    @State var selectedPhoto: PhotosPickerItem?
    @State var selectedPhotoData: Data?

    var body: some View {
        NavigationStack {
            Form {
//                TextField("Id", text: $id)
                TextField("Title", text: $title)
                TextField("Description", text: $desc)
                
                Section {
                    if let selectedPhotoData,
                       let uiImage = UIImage(data: selectedPhotoData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, maxHeight: 300)
                    }
                    
                    PhotosPicker(selection: $selectedPhoto,
                                 matching: .images,
                                 photoLibrary: .shared()) {
                        Label("Add Image", systemImage: "photo")
                    }
                    
                    if selectedPhotoData != nil {
                        Button(role: .destructive) {
                            withAnimation {
                                selectedPhoto = nil
                                selectedPhotoData = nil
                            }
                        } label: {
                            Label("Remove Image", systemImage: "xmark")
                                .foregroundStyle(.red)
                        }
                    }
                }
                
                Button("Add City") {
                    let newCity = City(id: UUID().uuidString, title: title, desc: desc, image: selectedPhotoData!)
                    modelContext.insert(newCity)
                    dismiss()
                }
                .disabled(selectedPhotoData == nil)
            }
            .navigationTitle("New City")
            .task(id: selectedPhoto) {
                if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                    selectedPhotoData = data
                }
            }
        }
    }
}

#Preview {
    AddCityView()
}
