import Vapor
import Foundation

struct DisplayNumberRequest: Codable {
    let number: Int
    
    enum CodingKeys: String, CodingKey {
        case number
    }
}
