import KituraMarkdown


func initializeMarkdownRoutes(app: App) {
    // Add KituraMarkdown as a TemplateEngine
    app.router.add(templateEngine: KituraMarkdown())

    app.router.setDefault(templateEngine: KituraMarkdown())

    app.router.get("/docs") { _, response, next in
        response.headers["Content-Type"] = "text/html"
        try response.render("/docs/index.md", context: [String:Any]())
        response.status(.OK)
        next()
    }

    app.router.get("/docs/*") { request, response, next in
        response.headers["Content-Type"] = "text/html"
        if request.urlURL.path != "/docs/" {
            try response.render(request.urlURL.path, context: [String:Any]())
            response.status(.OK)
        }
        next()
    }
}
