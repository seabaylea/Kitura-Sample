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

import Credentials
import CredentialsFacebook
import CredentialsGoogle
import KituraSession

func initializeOauth2Routes(app: App) {
    
    // Session is required to keep user logged in after authentication
    let session = Session(secret: "AuthSecret", cookie: [CookieParameter.name("Kitura-Auth-cookie")])
    app.router.all("/oauth2", middleware: session)
    
    let oauthCredentials = Credentials()

    // Replace these values for your application from https://developers.facebook.com/apps/
    let fbClientId = "your facebook id"
    let fbCallbackUrl = "http://localhost:8080/oauth2/facebook/callback"
    let fbClientSecret = "your facebook secret"
    
    let fbCredentials = CredentialsFacebook(clientId: fbClientId, clientSecret: fbClientSecret, callbackUrl: fbCallbackUrl, options: ["scope":"email", "fields": "id,first_name,last_name,name,picture,email"])
    oauthCredentials.options["failureRedirect"] = "/oauth2.html"
    oauthCredentials.options["successRedirect"] = "/oauth2/success"

    oauthCredentials.register(plugin: fbCredentials)
    app.router.get("/oauth2/facebook", handler: oauthCredentials.authenticate(credentialsType: fbCredentials.name))
    app.router.get("/oauth2/facebook/callback", handler: oauthCredentials.authenticate(credentialsType: fbCredentials.name))

    app.router.get("/oauth2/success") { request, response, next in
        // check user profile for successful login
        guard let user = request.userProfile else {
            return try response.status(.unauthorized).end()
        }
        print("user.displayName \(user.displayName)")
        try response.send("hello \(user.displayName)").end()
    }
    
    app.router.get("/oauth2/protected") { request, response, next in
        // check user profile for successful login
        guard let user = request.userProfile else {
            return try response.send("Not authorized to view this route").end()
        }
        print("user.displayName \(user.displayName)")
        try response.send("hello \(user.displayName)").end()
    }
}
