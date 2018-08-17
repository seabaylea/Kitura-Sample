import Credentials
import CredentialsGoogle
import CredentialsFacebook

struct MultiTokenAuth: TypeSafeMultiCredentials {
    
    static var authenticationMethods: [TypeSafeCredentials.Type] = [GoogleTokenProfile.self, FacebookTokenProfile.self]
    
    let id: String
    let name: String
    let provider: String
    
    init(successfulAuth: TypeSafeCredentials) {
        self.id = successfulAuth.id
        self.provider = successfulAuth.provider
        switch successfulAuth {
            case let googleToken as GoogleTokenProfile:
                self.name = googleToken.name
            case let facebookToken as FacebookTokenProfile:
                self.name = facebookToken.name
            default:
                self.name = successfulAuth.id
        }
    }
}
