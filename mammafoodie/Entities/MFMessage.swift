import Foundation
import JSQMessagesViewController

struct MFMessage {
    var id:String = ""
    var senderId : String = ""
    var messageText : String = ""
    var dateTime : String = ""
    var senderDisplayName:String = ""
    
    init(with senderDisplayName: String,  messagetext: String, senderId: String) {
        self.senderDisplayName = senderDisplayName
        self.messageText = messagetext
        self.senderId = senderId
        self.dateTime = Date.timeIntervalSinceReferenceDate.description
    }
    
    init(from dictionary: [String:AnyObject]){
        self.id = dictionary["id"] as? String ?? ""
        self.senderId = dictionary["senderId"] as? String ?? ""
        self.messageText = dictionary["messageText"]   as? String ?? ""
        self.dateTime = dictionary["dateTime"]  as? String ?? ""
        self.senderDisplayName = dictionary["senderDisplayName"] as? String ?? ""
        
    }
    
}

public enum Setting: String{
    case removeSenderDisplayName = "Remove sender Display Name"
    case removeAvatar = "Remove Avatars"
}
