import Vapor
import Foundation

struct LightRequest: Codable {
    let toggleOn : Bool

    enum CodingKeys: String, CodingKey {
        case toggleOn
    }
}