import Foundation
import UIKit

struct MFConversation {
    var id: String = ""
    var user1:String = ""
    var user2:String = ""
    var createdAt:String = ""
    var user1Name:String = ""
    var user2Name:String = ""
    
    
    init(){
        
    }
    
    init(from dictionary:[String:AnyObject]){
        self.id = dictionary["id"] as? String ?? ""
        self.user1 = dictionary["user1"] as? String ?? ""
        self.user2 = dictionary["user2"] as? String ?? ""
        self.user1Name = dictionary["user1Name"] as? String ?? ""
        self.user2Name = dictionary["user2Name"] as? String ?? ""
        self.createdAt = dictionary["createdAt"] as? String ?? ""
    }
    
    
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
