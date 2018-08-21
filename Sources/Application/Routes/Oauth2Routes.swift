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
    
    // Session is required to keep the user logged in after authentication
    // If a user is logged in with a redirecting authentication, all routes with this session will have a userProfile
    let session = Session(secret: "AuthSecret", cookie: [CookieParameter.name("Kitura-Auth-cookie")])
    app.router.all("/oauth2", middleware: session)
    
    let oauthFBCredentials = Credentials()

    // Replace these values for your application from https://developers.facebook.com/apps/
    let fbClientId = "<your app ID>"
    let fbClientSecret = "<your app secret>"
    
    // Your app callback route which has credentials registered on it
    let fbCallbackUrl = app.cloudEnv.url + "/oauth2/facebook/callback"
    
    let fbCredentials = CredentialsFacebook(clientId: fbClientId, clientSecret: fbClientSecret, callbackUrl: fbCallbackUrl, options: ["scope":"email", "fields": "id,first_name,last_name,name,picture,email"])
    oauthFBCredentials.options["failureRedirect"] = "/oauth2.html"
    oauthFBCredentials.options["successRedirect"] = "/facebookloggedin.html"

    oauthFBCredentials.register(plugin: fbCredentials)
    // Login route
    app.router.get("/oauth2/facebook", handler: oauthFBCredentials.authenticate(credentialsType: fbCredentials.name))
    // App callback route
    app.router.get("/oauth2/facebook/callback", handler: oauthFBCredentials.authenticate(credentialsType: fbCredentials.name))
    
    app.router.get("/oauth2/protected") { request, response, next in
        // check user profile for successful login
        guard let user = request.userProfile else {
            return try response.send("Not authorized to view this route").end()
        }
        try response.send("hello \(user.displayName)").end()
    }
    
    app.router.get("/oauth2/logout") { request, response, next in
        // check user profile for successful login
        guard let user = request.userProfile else {
            return try response.send("You are not currently logged in").end()
        }
        oauthFBCredentials.logOut(request: request)
        return try response.send("User: \(user.displayName) successfully logged out").end()
    }
}
