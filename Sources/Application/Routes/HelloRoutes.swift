func initializeHelloRoutes(app: App) {
    app.router.get("/hello") { _, response, next in
        response.headers["Content-Type"] = "text/plain; charset=utf-8"
        try response.send("Hello, from Kitura!").end()
    }

    // This route accepts POST requests
    app.router.post("/hello") {request, response, next in
        response.headers["Content-Type"] = "text/plain; charset=utf-8"
        try response.send("Got a POST request").end()
    }

    // This route accepts PUT requests
    app.router.put("/hello") {request, response, next in
        response.headers["Content-Type"] = "text/plain; charset=utf-8"
        try response.send("Got a PUT request").end()
    }

    // This route accepts DELETE requests
    app.router.delete("/hello") {request, response, next in
        response.headers["Content-Type"] = "text/plain; charset=utf-8"
        try response.send("Got a DELETE request").end()
    }
}
