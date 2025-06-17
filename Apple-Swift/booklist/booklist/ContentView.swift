//
//  ContentView.swift
//  booklist
//
//  Created by Nianwen Dan on 2/18/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: MyBookList = MyBookList()
    @State var showAddBook = false
    @State var showDeleteBook = false
    @State var showSearchBook = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            VStack {
                let previewBookIndex = viewModel.previewBookIndex()
                if let previewBookIndex = previewBookIndex {
                    let bookInfo = viewModel.getBookInfo(index: previewBookIndex)
                    BookView(bookTitle: bookInfo["title"]!,
                             bookAuthor: bookInfo["author"]!,
                             bookGenre: bookInfo["genre"]!,
                             bookPrice: bookInfo["price"]!
                    )
                } else {
                    Text("Preview Unavaiable")
                    Text("Please add your first book")
                }
                toolbar
            }
            .navigationTitle("BookList")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showAddBook) {
                AddBook(showAddBook: $showAddBook, viewModel: viewModel)
            }
            .sheet(isPresented: $showDeleteBook) {
                deleteBook(showDeleteBook: $showDeleteBook, viewModel: viewModel)
            }
            .sheet(isPresented: $showSearchBook) {
                searchBook(showSearchBook: $showSearchBook, viewModel: viewModel)
            }
            .padding()
        }
    }
    
    var toolbar: some View {
        VStack {
            
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                // Search Book
                Button(action: {
                    showSearchBook = true
                }, label: {
                    Image(systemName: "magnifyingglass")
                })
                .disabled(!viewModel.hasBook())
            }
            
            ToolbarItemGroup(placement: .bottomBar) {
                // Add Book
                Button(action: {
                    showAddBook = true
                }, label: {
                    Image(systemName: "rectangle.stack.badge.plus")
                })
                
                // Delete Book
                Button(action: {
                    showDeleteBook = true
                }, label: {
                    Image(systemName: "rectangle.stack.badge.minus")
                })
                .disabled(!viewModel.hasBook())
                
                Spacer()
                
                // Preview Previous Book
                Button(action: {
                    let result = viewModel.bookPreviewAdjester(by: -1)
                    if result == nil {
                        alertMessage = "No previous book available."
                        showAlert = true
                    }
                }, label: {
                    Text("Previous")
                })
                .disabled(viewModel.previewBookIndex() == nil)
                
                // Preview Next Book
                Button(action: {
                    let result = viewModel.bookPreviewAdjester(by: 1)
                    if result == nil {
                        alertMessage = "No next book available."
                        showAlert = true
                    }
                }, label: {
                    Text("Next")
                })
                .disabled(viewModel.previewBookIndex() == nil)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Opps..."), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

struct BookView: View {
    let bookTitle: String
    let bookAuthor: String
    let bookGenre: String
    let bookPrice: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(.cyan)
                .opacity(0.7)
            VStack {
                Text("Title: \(bookTitle)")
                    .font(.title)
                Text("Author: \(bookAuthor)")
                Text("Genre: \(bookGenre)")
                Text("Price \(bookPrice)")
            }
        }
    }
}

struct AddBook: View {
    @Binding var showAddBook: Bool
    @ObservedObject var viewModel: MyBookList
    @State var bookTitle = ""
    @State var bookAuthor = ""
    @State var bookGenre = ""
    @State var bookPrice = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Book Title", text: $bookTitle)
                TextField("Book Author", text: $bookAuthor)
                TextField("Book Genre", text: $bookGenre)
                TextField("Book Price", text: $bookPrice)
            }
            .navigationBarTitle("Add Book")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(action: {
                    viewModel.addBook(title: bookTitle,
                                      author: bookAuthor,
                                      genre: bookGenre,
                                      price: Double(bookPrice) ?? -1.0)
                    showAddBook = false
                }, label: {
                    Image(systemName: "checkmark")
                })
                .disabled(bookTitle == "")
            }
        }
    }
}


struct deleteBook: View {
    @Binding var showDeleteBook: Bool
    @ObservedObject var viewModel: MyBookList
    @State var bookTitle = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Book Title", text: $bookTitle)
            }
            .navigationBarTitle("Delete Book")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(action: {
                    viewModel.deleteBook(title: bookTitle)
                    showDeleteBook = false
                }, label: {
                    Image(systemName: "checkmark")
                })
            }
        }
        
    }
}

struct searchBook: View {
    @Binding var showSearchBook: Bool
    @ObservedObject var viewModel: MyBookList
    
    @State var seachBookTitle = ""
    @State private var bookIndex: Int?
    @State private var foundBook = false
    @State private var showAlert = false
    
    @State var bookTitle = ""
    @State var bookAuthor = "N/A"
    @State var bookGenre = "N/A"
    @State var bookPrice = "N/A"

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Type your Book Title", text: $seachBookTitle)
                }
                Button("Search") {
                    if let result = viewModel.searchBookIndex(title: seachBookTitle) {
                        bookIndex = result
                        foundBook = true
                        showAlert = true
                        let bookInfo = viewModel.getBookInfo(index: result)
                        bookTitle = bookInfo["title"]!
                        bookAuthor = bookInfo["author"]!
                        bookGenre = bookInfo["genre"]!
                        bookPrice =  bookInfo["price"]!
                    } else {
                        foundBook = false
                        bookTitle = "Cannot Find the Book"
                    }
                }
                Text("You need to seach book first!")
                Section("Search Result") {
                    TextField("Book Title", text: $bookTitle)
                    TextField("Book Author", text: $bookAuthor)
                    TextField("Book Genre", text: $bookGenre)
                    TextField("Book Price", text: $bookPrice)
                }
                .disabled(foundBook == false)
                Button("Update Book") {
                    viewModel.editBook(index: bookIndex!,
                                       title: bookTitle,
                                       author: bookAuthor,
                                       genre: bookGenre,
                                       price: Double(bookPrice) ?? -1.0
                    )
                    showSearchBook = false
                }
                .disabled(foundBook == false)
            }
            .navigationBarTitle("Search Book")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Message"), message: Text("We found the book!\nYou may edit the book now!"), dismissButton: .default(Text("OK")))
            }
        }
    }
}


#Preview {
    ContentView()
}
