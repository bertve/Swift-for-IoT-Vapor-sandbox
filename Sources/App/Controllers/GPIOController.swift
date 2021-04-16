import Vapor

public struct GPIOController: RouteCollection {
    let service = GPIOService.sharedInstance

    public func boot(routes: RoutesBuilder) throws {

        service.setup()

        let gpio = routes.grouped("gpio") 

        gpio.group("light") { light in
            light.post(use: toggleLight)
        }

        gpio.group("display") { display in 
            display.post(use: displayNumber)

            display.group("increment") { inc in
                inc.get(use: incrementDisplay)
            }

            display.group("decrement") { decr in
                decr.get(use: decrementDisplay)
            }
        }

        gpio.group("temperature") { temp in
            temp.get(use: getTempRep)
        }

    }
    
    func toggleLight(req: Request) -> String {
        if let toggleLightReq : ToggleLightRequest = try? req.content.decode(ToggleLightRequest.self) {
            let state : LightState = toggleLightReq.toggleOn ? .onn : .off
            service.toggleLight(state)
            return "toggled light \(state.rawValue)"
        } else {
            return "FAIL: toggling light failed"
        }
    }

    func incrementDisplay(req: Request) -> String {
        service.incrementDisplay()
        return "display incremented"
    }

    func decrementDisplay(req: Request) -> String {
        service.decrementDisplay()
        return "display decremented"
    }

    func displayNumber(req: Request) -> String {
        if let displayReq : DisplayRequest = try? req.content.decode(DisplayRequest.self) {
            let number: Int = displayReq.number
            service.display(number)
            return "displayed \(number)"
        } else {
            return "FAIL: displaying number"
        }
    }

    func getTempRep(req: Request) -> String {
        var objT: String = "No object temp available"
        var ambT: String = "No ambient temp available"

        if let oT = service.objectTemp {
            objT = String(oT)
        }

        if let aT = service.ambientTemp {
            ambT = String(aT)
        }

        return """
        -------------TEMPERATURES-------------
        object temp: \(objT)C°
        ambient temp: \(ambT)C°
        --------------------------------------
        """
    }
}