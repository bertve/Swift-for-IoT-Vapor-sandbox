import Vapor

struct ToggleLightRequest: Content {
    let toggleOn : Bool
}