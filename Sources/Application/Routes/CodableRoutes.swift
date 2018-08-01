/**
 * Copyright IBM Corporation 2018
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

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
