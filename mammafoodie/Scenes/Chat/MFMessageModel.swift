

import Foundation
import JSQMessagesViewController

struct MFMessage {
    var senderId : String = ""
    var messageText : String = ""
    var messageid : String = ""
    var conversationId : String = ""
    var receiverId : String = ""
    var datetime : String?
    var SenderCopyDeleted : Bool?
    var ReceiverCopyDeleted : Bool?
    var senderDisplayName:String = ""
    
//    var displayName : String = ""
//    var text : String = ""
//    var date : String = ""

    init(with senderDisplayName: String,  messagetext: String, senderId: String) {
//        self.name = name
        self.messageText = messagetext
//        self.senderId = userID
    }
    
}

