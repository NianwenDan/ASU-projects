//
//  AddMovieView.swift
//  lab5
//
//  Created by Nianwen Dan on 3/9/24.
//

import SwiftUI
import PhotosUI

struct AddMovieView: View {
    @Binding var path: NavigationPath
    @ObservedObject var viewModel: MovieListViewModel
    
    @State var name: String = ""
    @State var genre: String = ""
    @State var picture: UIImage = UIImage(resource: .posterPlaceholder)
    @State var description: String = ""
    
    @State var photoPickerItem: PhotosPickerItem?
    
    var body: some View {
        Form {
            Section("Poster") {
                HStack {
                    Spacer()
                    PhotosPicker(selection: $photoPickerItem) {
                        Image(uiImage: picture)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    Spacer()
                }
            }
            
            Section("Details") {
                TextField("Movie Title", text: $name)
                TextField("Movie Genre", text: $genre)
                TextField("Description", text: $description)
            }
        }
        .navigationTitle("New Movie")
        .toolbar {
            Button(action: {
                var _ = print(path)
                // Save to the model
                viewModel.add(name: name, genre: genre, description: description, picture: picture)
                path.removeLast(path.count)
            }, label: {
                Image(systemName: "square.and.arrow.down")
            })
            .disabled(name == "")
        }
        .onChange(of: photoPickerItem) {
            Task {
                if let photoPickerItem,
                   let data = try await photoPickerItem.loadTransferable(type: Data.self) {
                    if let image = UIImage(data: data) {
                        picture = image
                    }
                }
            }
        }
    }
}

#Preview {
    AddMovieView(path: .constant(NavigationPath()), viewModel: MovieListViewModel())
}
