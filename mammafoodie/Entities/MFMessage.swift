import Foundation
import JSQMessagesViewController

struct MFMessage {
    var id:String = ""
    var senderId : String = ""
    var messageText : String = ""
    //    var messageid : String = ""
    //    var conversationId : String = ""
    //    var receiverId : String = ""
    var dateTime : String = ""
    //    var SenderCopyDeleted : Bool?
    //    var ReceiverCopyDeleted : Bool?
    var senderDisplayName:String = ""
    
    //    var displayName : String = ""
    //    var text : String = ""
    //    var date : String = ""
    
    
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
        //        self.conversationId = dictionary["conversationId"] as? String ?? ""
        self.dateTime = dictionary["dateTime"]  as? String ?? ""
        self.senderDisplayName = dictionary["senderDisplayName"] as? String ?? ""
        
    }
    
}
func getAvatar() -> JSQMessagesAvatarImage{
    let avatarAditya = JSQMessagesAvatarImageFactory.avatarImage(withPlaceholder: #imageLiteral(resourceName: "Bitmap"), diameter: 20)!//   (withUserInitials: "AS", backgroundColor: UIColor.jsq_messageBubbleGreen(), textColor: UIColor.white, font: UIFont.systemFont(ofSize: 12), diameter: 20)!
    return avatarAditya
}
public enum Setting: String{
    case removeSenderDisplayName = "Remove sender Display Name"
    case removeAvatar = "Remove Avatars"
}
