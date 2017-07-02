import Foundation
import UIKit

class MFComment {
    var id: String!
    var text: String!
    var createdAt: Date!
    var user: MFUser?
    var media: MFMedia?
    var username: String!
    
    init(text: String, username: String, userId: String) {
        self.text = text
        
        let user: MFUser = MFUser()
        user.name = username
        user.id = userId
        self.user = user
    }
    
    init(){
        
    }
    
    init(from commentDictionary:[String:AnyObject]) {
        
        self.id = commentDictionary["id"] as? String ?? ""
        self.text = commentDictionary["text"] as? String ?? ""
        let createdDateString = commentDictionary["createdAt"] as? String ?? ""
        self.createdAt = Date(fromString:createdDateString, format: .isoDateTimeSec)
        
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
