import KituraStencil
import LoggerAPI
import Stencil

func initializeStencilRoutes(app: App) {
   // add Stencil Template Engine with a extension with a custom tag
    let _extension = Extension()
    // from https://github.com/kylef/Stencil/blob/master/ARCHITECTURE.md#simple-tags
    _extension.registerSimpleTag("custom") { _ in
        return "Hello World"
    }

    let templateEngine = StencilTemplateEngine(extension: _extension)
    app.router.add(templateEngine: templateEngine,
               forFileExtensions: ["html"])

    // the example from https://github.com/kylef/Stencil
    let stencilContext: [String: Any] = [
        "articles": [
            [ "title": "Migrating from OCUnit to XCTest", "author": "Kyle Fuller" ],
            [ "title": "Memory Management with ARC", "author": "Kyle Fuller" ],
        ]
    ]

    app.router.get("/articles") { _, response, next in
        defer {
            next()
        }
        do {
            try response.render("document.stencil", context: stencilContext).end()
        } catch {
            Log.error("Failed to render template \(error)")
        }
    }

    app.router.get("/articles.html") { _, response, next in
        defer {
            next()
        }
        do {
            // we have to specify file extension here since it is not the extension of Stencil
            try response.render("document.html", context: stencilContext).end()
        } catch {
            Log.error("Failed to render template \(error)")
        }
    }

    app.router.get("/articles_subdirectory") { _, response, next in
        defer {
            next()
        }
        do {
            try response.render("subdirectory/documentInSubdirectory.stencil",
                                context: stencilContext).end()
        } catch {
            Log.error("Failed to render template \(error)")
        }
    }

    app.router.get("/articles_include") { _, response, next in
        defer {
            next()
        }
        do {
            try response.render("includingDocument.stencil",
                                context: stencilContext).end()
        } catch {
            Log.error("Failed to render template \(error)")
        }
    }

    app.router.get("/custom_tag_stencil") { _, response, next in
        defer {
            next()
        }
        do {
            try response.render("customTag.stencil", context: [:]).end()
        } catch {
            Log.error("Failed to render template \(error)")
        }
    }
}
