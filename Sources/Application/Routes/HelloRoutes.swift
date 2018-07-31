<<<<<<< HEAD
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
=======
>>>>>>> added sessions and authentication

func initializeHelloRoutes(app: App) {
    
    app.router.get("/hello") { _, response, next in
<<<<<<< HEAD
        let name = app.getName()
        try response.send("Hello \(name ?? "World"), from Kitura!").end()
=======
        try response.send("Hello, from Kitura!").end()
>>>>>>> added sessions and authentication
    }
    
    // This route accepts JSON or URLEncoded POST requests
    app.router.post("/hello") {request, response, next in
<<<<<<< HEAD
        let name = try request.readString()
        app.setName(name)
        try response.send("Got a POST request").end()
=======
        let inputName = try request.read(as: Name.self)
        try response.send("Got a POST request from \(inputName.name)").end()
>>>>>>> added sessions and authentication
    }

    // This route accepts PUT requests
    app.router.put("/hello") {request, response, next in
<<<<<<< HEAD
        let name = try request.readString()
        app.setName(name)
        try response.send("Got a PUT request").end()
=======
        let inputName = try request.read(as: Name.self)
        try response.send("Got a PUT request from \(inputName.name)").end()
>>>>>>> added sessions and authentication
    }

    // This route accepts DELETE requests
    app.router.delete("/hello") {request, response, next in
<<<<<<< HEAD
        app.setName(nil)
=======
>>>>>>> added sessions and authentication
        try response.send("Got a DELETE request").end()
    }
}

extension App {
    func setName(_ name: String?) {
        nameSemaphore.wait()
        self.name = name
        nameSemaphore.signal()
    }
    func getName() -> String? {
        nameSemaphore.wait()
        let safeName = name
        nameSemaphore.signal()
        return safeName
    }
}
