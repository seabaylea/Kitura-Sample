import KituraContracts
import Credentials
import CredentialsHTTP

func initializeAuthenticationRoutes(app: App) {
    // Codable Authentication
    app.router.get("/basic") { (user: MyBasicAuth, respondWith: (MyBasicAuth?, RequestError?) -> Void) in
        print("authenticated \(user.id) using \(user.provider)")
        respondWith(user, nil)
    }
    
    let credentials = Credentials()
    credentials.register(plugin: app.basicCredentials)
    app.router.all("/rawbasic", middleware: credentials)
    app.router.get("/rawbasic") { request, response, next in
        guard let user = request.userProfile else {
            return try response.status(.internalServerError).end()
        }
        try response.send("authenticated \(user.id)").end()
    }
}

extension App {
    // Raw authentication
    static let users = ["username" : "password", "Mary" : "qwerasdf"]
    
    var basicCredentials: CredentialsHTTPBasic {
        let basicCreds = CredentialsHTTPBasic(verifyPassword: { userId, password, callback in
            if let storedPassword = App.users[userId], storedPassword == password {
                callback(UserProfile(id: userId, displayName: userId, provider: "HTTPBasic"))
            } else {
                callback(nil)
            }
        })
        basicCreds.realm = "HTTP Basic authentication: Username = username, Password = password"
        return basicCreds
    }
}
