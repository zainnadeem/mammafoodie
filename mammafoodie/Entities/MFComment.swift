import Foundation
import UIKit

class MFComment {
    var id: String!
    var text: String!
    var createdAt: Date!
    var user: MFUser!
    var refrenceID: String!
    
    init(with text: String, user: MFUser, refrence: String) {
        self.id = FirebaseReference.newsFeedComments.generateAutoID()
        self.text = text
        self.user = user
        self.refrenceID = refrence
        self.createdAt = Date.init()
    }
    
    init(from commentDictionary: [String: AnyObject]) {
        self.id = commentDictionary["id"] as? String ?? ""
        if let userComment = commentDictionary["user"] as? [String: AnyObject] {
            self.user = MFUser.init(from: userComment)
        }
        self.refrenceID = commentDictionary["refrenceID"] as? String ?? ""
        self.text = commentDictionary["text"] as? String ?? ""
        let timeStamp: TimeInterval = commentDictionary["createdAt"] as? Double ?? 0
        self.createdAt = Date.init(timeIntervalSinceReferenceDate: timeStamp)
    }
}

extension MFComment: Hashable {
    var hashValue: Int {
        return self.id.hashValue
    }
}

extension MFComment: Equatable {
    static func ==(lhs: MFComment, rhs: MFComment) -> Bool {
        return lhs.id == rhs.id
    }
}
