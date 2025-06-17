//
//  BookList.swift
//  booklist
//
//  Created by Nianwen Dan on 2/18/24.
//

import Foundation

struct BookList {
    private(set) var books: Array<Book>
    public var previewBook: Int?
    
    init() {
        self.books = []
        self.previewBook = nil
    }
    
    init(books: Array<Book>) {
        self.books = books
        self.previewBook = nil
    }
    
    mutating func addBook(titleIs title: String, authorIs author: String, genreIs genre: String, priceIs price: Double) {
        let newBook = Book(
            bookTitle: title,
            bookAuthor: author,
            bookGenre: genre,
            bookPrice: price
        )
        
        self.books.append(newBook)
        // Update Preview Book
        previewBook = books.endIndex - 1
        print(books)
        print("---")
    }
    
    mutating func deleteBook(titleIs title: String) {
        books.removeAll { $0.bookTitle == title }
        
        // Update Preview Book
        previewBook = books.isEmpty ? nil : 0
    }
    
    mutating func modifyBook(index: Int, newTitle title: String, newAuthor author: String, newGenre genre: String, newPrice price: Double) {
        books[index].bookTitle = title
        books[index].bookAuthor = author
        books[index].bookGenre = genre
        books[index].bookPrice = price
        print(index)
        print(books)
    }
    
    func searchBook(titleIs bookTitle: String) -> Int? {
        for index in books.indices {
            if books[index].bookTitle == bookTitle {
                return index
            }
        }
        return nil
    }
    
    struct Book {
        var bookTitle: String? = nil
        var bookAuthor: String? = nil
        var bookGenre: String? = nil
        var bookPrice: Double? = nil
    }
}
