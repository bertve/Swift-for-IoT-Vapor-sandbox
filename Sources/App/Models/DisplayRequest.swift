import Vapor

struct DisplayRequest: Content {
    var number: Int
}

extension DisplayRequest: Validatable {
    static func validations(_ validations: inout Validations){
        validations.add("digit", as: Int.self, is: .range(0...9999))
    }
}