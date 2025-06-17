//
//  ContentView.swift
//  lab5
//
//  Created by Nianwen Dan on 3/9/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = MovieListViewModel()
    
    @State private var path = NavigationPath()
    @State private var navigateToAddMovie = false
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                // Iterate over the dictionary keys (letters) and sort them
                ForEach(viewModel.getSortedKeys(), id: \.self) { letter in
                    // Optional: Use `if let` to safely unwrap the movie array for each letter

                    Section(header: Text(String(letter))) {
                        // Iterate over the movies for this letter
                        ForEach(viewModel.getMoviesList(key: letter), id: \.id) { movie in
                            NavigationLink(destination: MovieDetailView(name: movie.name,
                                                                        genre: movie.genre,
                                                                        picture: movie.picture,
                                                                        description: movie.description)) {
                                listMovieView(poster: movie.picture, title: movie.name, description: movie.description)
                            }
                        }
                        .onDelete(perform: { indexSet in
                            viewModel.delete(from: letter, at: indexSet)
                        })
                    }

                }
            }
            .navigationTitle("Watched Movies")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    NavigationLink("Add", value: "navigateToAddMovie")
                }
            }
            .navigationDestination(for: String.self) { item in
                if item == "navigateToAddMovie" {
                    AddMovieView(path: $path, viewModel: viewModel)
                }
            }
        }
    }
}

struct listMovieView: View {
    var poster: UIImage
    var title: String
    var description: String
    
    var body: some View {
        HStack {
            Image(uiImage: poster)
                .resizable()
                .aspectRatio(1/1.5, contentMode: .fill)
                .frame(width: 54, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 3))
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .minimumScaleFactor(1)
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .lineLimit(2)
                    .minimumScaleFactor(1)
            }
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
