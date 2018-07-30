import LoggerAPI

func initializeErrorRoutes(app: App) {
    app.router.get("/error") { _, response, next in
        Log.error("Example of error being set")
        response.status(.internalServerError)
        response.error = SampleError.sampleError
        // Set status code to 200, because status code 500 doesn't display the message in a web
        // broswer window.
        response.statusCode = .OK
        next()
    }
    
    // Handles any errors that get set
    app.router.error { request, response, next in
        response.headers["Content-Type"] = "text/plain; charset=utf-8"
        let errorDescription: String
        if let error = response.error {
            errorDescription = "\(error)"
        } else {
            errorDescription = "Unknown error"
        }
        try response.send("Caught the error: \(errorDescription)").end()
    }
}

enum SampleError: Error {
    case sampleError
}

extension SampleError: CustomStringConvertible {
    var description: String {
        switch self {
        case .sampleError:
            return "Example of error being set"
        }
    }
}
