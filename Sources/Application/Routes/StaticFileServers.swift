import Foundation
import Kitura
import LoggerAPI

func initializeStaticFileServers(app: App) {
    app.router.all("/static", middleware: StaticFileServer())
    app.router.all("/chat", middleware: StaticFileServer(path: "./chat"))
    app.router.all("/", middleware: StaticFileServer(path: "./Views"))
    app.router.get("/") { request, response, next in
        response.headers["Content-Type"] = "text/html; charset=utf-8"
        do {
            try response.render("home.html", context: [String: Any]()).end()
        } catch {
            Log.error("Failed to render template \(error)")
        }
        
    }
}
