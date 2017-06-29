import Foundation
import UIKit

struct MFConversation {
    var id: String!
    var participants: [MFUser:Date] = [:]
    var createdAt: Date!
    var endedAt: Date?
    var dishRequestId: MFDishRequest?
}

extension MFConversation: Hashable {
    var hashValue: Int {
        return self.id.hashValue
    }
}

extension MFConversation: Equatable {
    static func ==(lhs: MFConversation, rhs: MFConversation) -> Bool {
        return lhs.id == rhs.id
    }
}
