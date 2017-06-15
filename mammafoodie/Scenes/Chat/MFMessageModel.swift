

import Foundation

struct Message {
    var name : String = ""
    var messageText : String = ""
    var messageId : Int
    var conversationId : Int
    var senderId : Int
    var receiverId : Int
    var datetime : Double
    var SenderCopyDeleted : String = ""
    var ReceiverCopyDeleted : String = ""
    
//    init(with name: String,  messagetext: String, userID: Int) {
//        self.name = name
//        self.messageText = messagetext
//        self.senderId = userID
//    }
}
