import Foundation
import Kitura
import LoggerAPI
import Configuration
import CloudEnvironment
import KituraContracts
import Health
import KituraOpenAPI

public let projectPath = ConfigurationManager.BasePath.project.path
public let health = Health()

public class App {
    let router = Router()
    let cloudEnv = CloudEnv()
    
    public init() throws {
        // Run the metrics initializer
        initializeMetrics(router: router)
        KituraOpenAPI.addEndpoints(to: router)
    }
    
    func postInit() throws {
        // Endpoints
        initializeHelloRoutes(app: self)
        initializeMultiHandlerRoutes(app: self)
        initializeStencilRoutes(app: self)
        initializeMarkdownRoutes(app: self)
        initializeErrorRoutes(app: self)
        initializeCodableRoutes(app: self)
        initializeHealthRoutes(app: self)
        initializeStaticFileServers(app: self)
        initializeMiscRoutes(app: self)
        initializeNotFoundRoute(app: self)
    }
    
    public func run() throws {
        try postInit()
        Kitura.addHTTPServer(onPort: cloudEnv.port, with: router)
        Kitura.run()
    }
}
