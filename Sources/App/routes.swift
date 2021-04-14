import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "test Vapor app works"
    }.description("says it works")

    try app.register(collection: GPIOController())
}
/*
// post json
    app.post("greeting") { req in 
        let greeting = try req.content.decode(Greeting.self)
        print(greeting.hello) // "world"
        return HTTPStatus.ok
    }

// struct of class inherets Content (vapor lib obj)
    struct Greeting: Content {
        var hello: String
    }
*/

/*    
//prefixing
    app.group("users") { users in
        // GET /users
        users.get { req in
            ...
        }
        // POST /users
        users.post { ... }

        users.group(":id") { user in
            // GET /users/:id
            user.get { req in
                let id = req.parameters.get("id")!
            }
            // PATCH /users/:id
            user.patch { ... }
            // PUT /users/:id
            user.put { ... }
        }
    }

*/

/*
// middleware bv.auth
    app.post("login") { ... }
    let auth = app.grouped(AuthMiddleware())
    auth.get("dashboard") { ... }
    auth.get("logout") { ... }
*/

/* 
// redirect
req.redirect(to: "/some/new/path")
// redirect permanent
req.redirect(to: "/some/new/path", type: .permanent)
*/


