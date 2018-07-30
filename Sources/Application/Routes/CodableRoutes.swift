import KituraContracts

func initializeCodableRoutes(app: App) {
    
   //Codable route for post
    app.router.post("/books", handler: persistBookHandler)

    //Codable route for get with and without parameters
    app.router.get("/books") { (query: BookQuery, respondWith: ([Book]?, RequestError?) -> Void) in
        // Filter data using query parameters provided to the application
        var books: [Book]
        if let bookName = query.name {
            books = bookStore.map({ $0.value }).filter( {
                ( $0.name == bookName )
            })
        } else {
            books = bookStore.map({ $0.value })
        }
        if books.count == 0 {
            let book = Book(name: "Sample", author: "zzz", rating: 5)
            books = [book!]
        }
        // Return list of books
        respondWith(books, nil)
    }
}

var bookStore: [String: Book] = [:]

func persistBookHandler(book: Book, completion: (Book?, RequestError?) -> Void ) {
    bookStore[book.name] = book
    completion(bookStore[book.name], nil)
}
