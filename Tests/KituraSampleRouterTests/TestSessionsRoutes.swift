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

import XCTest
import KituraNet
import Foundation
import KituraSession

class TestSessionsRoutes: KituraTest {
    
    static var allTests: [(String, (TestSessionsRoutes) -> () throws -> Void)] {
        return [
            ("testTypeSafeSession", testTypeSafeSession),
        ]
    }
    
    func testTypeSafeSession() {
        let emptyBooks: [Book] = []
        performServerTest(asyncTasks: { expectation in
            // Login to create the session and set session.sessionTestKey to be sessionTestValue
            self.performRequest("get", path: "/session", expectation: expectation, headers: ["cookie": "cookiename=cookievalue"], callback: { response in
                self.checkCodableResponse(response: response, expectedResponse: emptyBooks)
                expectation.fulfill()
            })
        })
    }
}
