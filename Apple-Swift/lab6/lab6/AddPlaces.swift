//
//  AddPlaces.swift
//  lab6
//
//  Created by Nianwen Dan on 3/19/24.
//

import SwiftUI
import PhotosUI

struct AddPlaces: View {
    @ObservedObject var viewModel: Cities
    @Binding var isShowAddNewPlace: Bool
    
    @State var cityName = ""
    @State var cityDesc = ""
    @State var cityPicture: UIImage = UIImage(resource: .cityImagePlaceholder)
    
    @State var photoPickerItem: PhotosPickerItem?
    
    var body: some View {
        NavigationStack {
            Form {
                Section("CITY PHOTO") {
                    HStack {
                        Spacer()
                        PhotosPicker(selection: $photoPickerItem) {
                            Image(uiImage: cityPicture)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        Spacer()
                    }
                }
                
                TextField("City Name", text: $cityName)
                TextField("Description", text: $cityDesc)
            }
            .navigationTitle("New Place")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(action: {
                    // Save to the model
                    viewModel.addCity(name: cityName, description: cityDesc, picture: cityPicture)
                    isShowAddNewPlace = false
                }, label: {
                    Text("Save")
                })
                .disabled(cityName == "")
            }
            .onChange(of: photoPickerItem) {
                Task {
                    if let photoPickerItem,
                       let data = try await photoPickerItem.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: data) {
                            cityPicture = image
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    AddPlaces(viewModel: Cities(), isShowAddNewPlace: .constant(true))
}
