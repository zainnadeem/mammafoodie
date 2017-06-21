class MFComment {
    var id: String!
    var text: String!
    var createdAt: Date!
    var user: MFUser!
    var media: MFMedia!
    
    init(text: String, username: String, userId: String) {
        self.text = text
        
        let user: MFUser = MFUser()
        user.name = username
        user.id = userId
        self.user = user
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
