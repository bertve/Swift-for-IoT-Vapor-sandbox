import Vapor
import Foundation

public struct GPIOController: RouteCollection {
    let service = GPIOService.sharedInstance

    let decoder = JSONDecoder()

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
    
    func toggleLight(req: Request) -> MessageResponse {
        print(req.body.string ?? "no body")
        print(req.headers)
        if let bodyString = req.body.string,
            let bodyData = bodyString.data(using: .utf8),
            let toggleLightReq = try? decoder.decode(LightRequest.self, from: bodyData) {
            
            let state : LightState = toggleLightReq.toggleOn ? .onn : .off
            service.toggleLight(state)
            return MessageResponse(message:"toggled light \(state.rawValue)")
        } else {
            return MessageResponse(message:"FAIL: toggling light failed")
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

    func displayNumber(req: Request) -> MessageResponse {
        print(req.body.string ?? "no body")
        print(req.headers)
        if let bodyString = req.body.string,
            let bodyData = bodyString.data(using: .utf8),
            let displayReq : DisplayNumberRequest = try? decoder.decode(DisplayNumberRequest.self, from: bodyData ){

            let number = displayReq.number
            if number >= 0 && number <= 9999 {
                service.display(number)
                return MessageResponse(message:"displayed \(number)")
            } else {
                return MessageResponse(message: "can't display \(number), display range [0,9999]")
            } 

        } else {
            return MessageResponse(message:"FAIL: displaying")
        }
    }

    func getTempRep(req: Request) -> MessageResponse {
        var objT: String = "No object temp available"
        var ambT: String = "No ambient temp available"

        if let oT = service.objectTemp {
            objT = String(oT)
        }

        if let aT = service.ambientTemp {
            ambT = String(aT)
        }

        return MessageResponse(message:"object temp: \(objT)C°\nambient temp: \(ambT)C°")
    }
}