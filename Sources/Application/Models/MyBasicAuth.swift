import CredentialsHTTP

public struct MyBasicAuth: TypeSafeHTTPBasic {
    static let authenticate = ["username" : "password"]
    public static let realm: String = "HTTP Basic authentication: Username = username, Password = password"
    
    public static func verifyPassword(username: String, password: String, callback: @escaping (MyBasicAuth?) -> Void) {
        if let storedPassword = authenticate[username], storedPassword == password {
            callback(MyBasicAuth(id: username))
            return
        }
        callback(nil)
    }
    
    public var id: String
}
