import Foundation
import Kitura
import LoggerAPI
import HeliumLogger
import Application
import KituraWebSocket

do {
    
    HeliumLogger.use(LoggerMessageType.info)
    WebSocket.register(service: ChatService(), onPath: "kitura-chat")
    let app = try App()
    try app.run()
    
} catch let error {
    Log.error(error.localizedDescription)
}
