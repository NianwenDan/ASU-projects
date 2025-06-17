//
//  MovieListModel.swift
//  lab5
//
//  Created by Nianwen Dan on 3/9/24.
//

import Foundation
import PhotosUI

struct MovieListModel {
    private(set) var movieDictionary: [Character: [Movie]] = [:]
    
    init() {
        testData()
    }
    
    mutating func add(name: String, genre: String, description: String, picture: UIImage) {
        let movie = Movie(name: name, genre: genre, picture: picture, description: description)
        
        // Get the first letter of the movie name
        if let firstLetter = name.first {
            // If the letter exists in the dictionary, append the movie to the array
            if var movies = movieDictionary[firstLetter] {
                movies.append(movie)
                movieDictionary[firstLetter] = movies
            } else {
                // Otherwise, create a new array with the movie in it
                movieDictionary[firstLetter] = [movie]
            }
        }
    }
    
    mutating func deleteMovies(letter: Character, at offsets: IndexSet) {
        guard var movies = movieDictionary[letter] else { return }
        movies.remove(atOffsets: offsets)
        
        if movies.isEmpty {
            movieDictionary.removeValue(forKey: letter)
        } else {
            movieDictionary[letter] = movies
        }
    }
    
    // These are test data insert into the dictionary
    private mutating func testData() {
        add(name: "The Dark Knight", genre: "Action, Crime, Drama", description: "When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.", picture: UIImage(named: "posterPlaceholder")!)
        add(name: "Inception", genre: "Action, Adventure, Sci-Fi", description: "A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a CEO.", picture: UIImage(named: "posterPlaceholder")!)
        add(name: "Fight Club", genre: "Drama", description: "An insomniac office worker and a devil-may-care soapmaker form an underground fight club that evolves into something much, much more.", picture: UIImage(named: "posterPlaceholder")!)
        add(name: "Pulp Fiction", genre: "Crime, Drama", description: "The lives of two mob hitmen, a boxer, a gangster and his wife, and a pair of diner bandits intertwine in four tales of violence and redemption.", picture: UIImage(named: "posterPlaceholder")!)
        add(name: "The Matrix", genre: "Action, Sci-Fi", description: "A computer hacker learns from mysterious rebels about the true nature of his reality and his role in the war against its controllers.", picture: UIImage(named: "posterPlaceholder")!)
    }

    
    struct Movie: Identifiable, Hashable {
        
        var name: String
        var genre: String
        var picture: UIImage
        var description: String
        
        var id = UUID()
    }
}
