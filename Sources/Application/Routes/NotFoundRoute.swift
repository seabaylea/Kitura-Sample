func initializeNotFoundRoute(app: App) {
    // A custom Not found handler
    app.router.all { request, response, next in
        if  response.statusCode == .unknown  {
            // Remove this wrapping if statement, if you want to handle requests to / as well
            let path = request.urlURL.path
            if  path != "/" && path != ""  {
                try response.status(.notFound).send("Route not found in Sample application!").end()
            }
        }
        next()
    }
}
