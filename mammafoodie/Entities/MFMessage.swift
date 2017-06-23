struct MFMessage {
    var id: String!
    var conversation: MFConversation!
    var text: String!
    var sender: MFUser!
    var receiver: MFUser!
    var createdAt: Date!
    var isSenderCopyDeleted: Bool = false
    var isReceiverCopyDeleted: Bool = false
    
    init(with senderDisplayName: String,  messagetext: String, senderId: String) {
        //        self.name = name
        self.text = messagetext
    }
}

extension MFMessage: Hashable {
    var hashValue: Int {
        return self.id.hashValue
    }
}

extension MFMessage: Equatable {
    static func ==(lhs: MFMessage, rhs: MFMessage) -> Bool {
        return lhs.id == rhs.id
    }
}
