//
//  MovieListViewModel.swift
//  lab5
//
//  Created by Nianwen Dan on 3/9/24.
//

import Foundation
import PhotosUI

class MovieListViewModel: ObservableObject {
    @Published private(set) var model = MovieListModel()
    
    func getMovieList() -> [Character : [MovieListModel.Movie]] {
        model.movieDictionary
    }
    
    func add(name: String, genre: String, description: String, picture: UIImage = UIImage(resource: .posterPlaceholder)) {
        model.add(name: name,
                  genre: genre,
                  description: description,
                  picture: picture)
    }
    
    func delete(from letter: Character, at offsets: IndexSet) {
        model.deleteMovies(letter: letter, at: offsets)
    }
    
    func getSortedKeys() -> [Character] {
        model.movieDictionary.keys.sorted()
    }
    
    func getMoviesList(key: Character) -> [MovieListModel.Movie] {
        let moviesForLetter = model.movieDictionary[key]
        return moviesForLetter ?? []
    }
}
