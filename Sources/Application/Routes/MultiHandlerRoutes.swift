func initializeMultiHandlerRoutes(app: App) {
    // Uses multiple handler blocks
    app.router.get("/multi", handler: { request, response, next in
        response.send("I'm here!\n")
        next()
    }, { request, response, next in
        response.send("Me too!\n")
        next()
    })

    app.router.get("/multi") { request, response, next in
        try response.send("I come afterward..\n").end()
    }
}
