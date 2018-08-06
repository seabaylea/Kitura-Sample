/**
 * Copyright IBM Corporation 2016
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

import XCTest
import KituraNet
import Foundation

class TestCodableRoutes: KituraTest {
    
    static var allTests: [(String, (TestCodableRoutes) -> () throws -> Void)] {
        return [
            ("testCodableGet", testCodableGet),
            ("testCodablePost", testCodablePost),
        ]
    }
    
    func testCodableGet() {
        let book: Book = Book(name: "Sample", author: "zzz", rating: 5)
        performServerTest { expectation in
            self.performRequest("get", path: "/books", expectation: expectation) { response in
                self.checkCodableResponse(response: response, expectedResponse: book)
                expectation.fulfill()
            }
        }
    }
    
    func testCodablePost() {
        let book: String = "{\"name\": \"xxx\",\"author\": \"yyy\",\"rating\": 4}"
        let expectedBook: Book = Book(name: "xxx", author: "yyy", rating: 4)
        performServerTest(asyncTasks: { expectation in
            self.performRequest("post", path: "/books", body: book, expectation: expectation, headers: ["Content-Type":"application/json"]) { response in
                self.checkCodableResponse(response: response, expectedResponse: expectedBook, expectedStatusCode: HTTPStatusCode.created)
                self.performRequest("get", path: "/books", expectation: expectation, headers: ["Content-Type":"application/json"]) { response in
                    self.checkCodableResponse(response: response, expectedResponse: expectedBook)
                    expectation.fulfill()
                }
            }
        })
    }
}


struct Book: Decodable {
    let name: String
    let author: String
    let rating: Int
}
