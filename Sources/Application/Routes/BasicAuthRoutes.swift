import KituraContracts
import Credentials
import CredentialsHTTP

func initializeBasicAuthRoutes(app: App) {
    // Codable Authentication
    app.router.post("/signup") { (user: SignUp, respondWith: (Name?, RequestError?) -> Void) in
        if UserPasswords.addPassword(username: user.username, password: user.password) {
            respondWith(Name(name: user.username), nil)
        } else {
            respondWith(nil, .conflict)
        }
    }
    
    app.router.get("/basic") { (user: MyBasicAuth, respondWith: (MyBasicAuth?, RequestError?) -> Void) in
        print("authenticated \(user.id) using \(user.provider)")
        respondWith(user, nil)
    }
    
    app.router.delete("/clearusers") { (respondWith: (RequestError?) -> Void) in
        UserPasswords.clearPasswords()
        respondWith(nil)
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
    var basicCredentials: CredentialsHTTPBasic {
        let basicCreds = CredentialsHTTPBasic(verifyPassword: { userId, password, callback in
            if UserPasswords.checkPassword(username: userId, password: password) {
                callback(UserProfile(id: userId, displayName: userId, provider: "HTTPBasic"))
            } else {
                callback(nil)
            }
        })
        basicCreds.realm = "HTTP Basic authentication: Username = username, Password = password"
        return basicCreds
    }
}
