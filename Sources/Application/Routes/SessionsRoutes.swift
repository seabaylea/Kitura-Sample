import KituraContracts
import KituraSession
func initializeSessionsRoutes(app: App) {
    // Codable Session
    app.router.get("/session") { (session: MySession, respondWith: ([Book]?, RequestError?) -> Void) -> Void in
        respondWith(session.books, nil)
    }

    app.router.post("/session") { (session: MySession, book: Book, respondWith: (Book?, RequestError?) -> Void) -> Void in
        session.books.append(book)
        session.save()
        respondWith(book, nil)
    }
    
    app.router.get("/logout") { (session: MySession, respondWith: (Book?, RequestError?) -> Void) -> Void in
        session.destroy()
        respondWith(nil,nil)
    }
    
    // Raw session
    let session = Session(secret: "secret", cookie: [CookieParameter.name("Raw-cookie")])
    app.router.all(middleware: session)
    
    app.router.get("/rawsession") { request, response, next in
        guard let session = request.session else {
            return try response.status(.internalServerError).end()
        }
        let bookData = session["books"] as? [[String: String]] ?? []
        var books: [Book] = []
        for book in bookData {
            guard let bookName = book["name"],
                  let bookAuthor = book["author"],
                  let ratingString = book["rating"],
                  let bookRating = Int(ratingString),
                  let newBook = Book(name: bookName, author: bookAuthor, rating: bookRating)
            else { continue }
            books.append(newBook)
        }
        // Work with your books from the session
        response.send(json: books)
        next()
    }
    
    app.router.post("/rawsession") { request, response, next in
        guard let session = request.session else {
            return try response.status(.internalServerError).end()
        }
        var bookData = session["books"] as? [[String: String]] ?? []
        let inputBook = try request.read(as: Book.self)
        let bookDict: [String: String] = ["name": inputBook.name, "author": inputBook.author, "rating": String(inputBook.rating)]
        bookData.append(bookDict)
        session["books"] = bookData
        response.status(.created)
        response.send(inputBook)
        next()
    }
    
    app.router.get("/rawlogout") { request, response, next in
        guard let session = request.session else {
            return try response.status(.internalServerError).end()
        }
        session["books"] = nil
        let _ = response.send(status: .OK)
        next()
    }
}
