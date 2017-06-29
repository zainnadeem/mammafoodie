import Foundation
import UIKit

struct MFDishRequest {
    var id: String!
    var dish: MFDish!
    var needDishOnDate: Date?
    var user: MFUser!
    var quantity: UInt = 0
    var cratedAt: Date!
}

extension MFDishRequest: Hashable {
    var hashValue: Int {
        return self.id.hashValue
    }
}

extension MFDishRequest: Equatable {
   static func ==(lhs: MFDishRequest, rhs: MFDishRequest) -> Bool {
        return lhs.id == rhs.id
    }
}
