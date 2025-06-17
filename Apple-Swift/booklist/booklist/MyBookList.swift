//
//  MyBookList.swift
//  booklist
//
//  Created by Nianwen Dan on 2/18/24.
//

import SwiftUI

class MyBookList: ObservableObject {
    @Published private var model = BookList();
    
    func addBook(title: String, author: String, genre: String, price: Double) {
        model.addBook(titleIs: title, authorIs: author, genreIs: genre, priceIs: price)
        self.objectWillChange.send()
    }
    
    func deleteBook(title: String) {
        model.deleteBook(titleIs: title)
        self.objectWillChange.send()
    }
    
    func previewBookIndex() -> Int? {
        model.previewBook
    }
    
    func getBookInfo(index: Int) -> [String: String] {
//        if (index >= 0 && index <= model.books.endIndex) {
//
//        }
        // FIXME: Check valid index
        let book = model.books[index]
        return ["title": book.bookTitle ?? "",
                "author": book.bookAuthor ?? "",
                "genre": book.bookGenre ?? "",
                "price": String(format: "%.2f", book.bookPrice ?? -1.0)
        ]
    }
    
    func bookPreviewAdjester(by offset: Int) -> Int? {
        if let previewBook = model.previewBook {
            let newPreviewBook = previewBook + offset
            if (newPreviewBook < model.books.count && newPreviewBook >= 0) {
                model.previewBook = newPreviewBook
                return model.previewBook
            }
        }
        return nil
    }
    
    func searchBookIndex(title: String) -> Int? {
        return model.searchBook(titleIs: title)
    }
    
    func editBook(index: Int, title: String, author: String, genre: String, price: Double) {
        model.modifyBook(index: index, newTitle: title, newAuthor: author, newGenre: genre, newPrice: price)
        self.objectWillChange.send()
    }
    
    func hasBook() -> Bool {
        if (model.books.isEmpty) {
            return false
        }
        return true
    }
}
