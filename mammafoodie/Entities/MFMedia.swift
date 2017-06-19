enum MFMediaType : String {
    case liveVideo = "liveVideo"
    case vidup = "vidup"
    case picture = "picture"
    case unknown = "unknown"
}

enum MediaAccessUserType {
    case owner
    case viewer
}

class MFMedia {
    var id: String!
    var comments: [Date:MFComment] = [:]
    var contentId: String!
    var cover_large: String?
    var cover_small: String?
    var createdAt: Date!
    var endedAt: Date?
    var dish: MFDish!
    var likes: [Date:MFUser] = [:]
    var numberOfViewers: UInt = 0
    var type: MFMediaType = .unknown
    var user: MFUser!
    
    
    var accessMode: MediaAccessUserType = .viewer
    
    init(id: String, cover_large: String, cover_small: String, createdAt: Date, dish: MFDish, user: MFUser, type: MFMediaType, numberOfViewers: UInt) {
        self.id = id
        self.cover_large = cover_large
        self.cover_small = cover_small
        self.createdAt = createdAt
        self.dish = dish
        self.user = user
        self.type = type
        self.numberOfViewers = numberOfViewers
    }
}

extension MFMedia: Hashable {
    var hashValue: Int {
        return self.id.hashValue
    }
}

extension MFMedia: Equatable {
    static func ==(lhs: MFMedia, rhs: MFMedia) -> Bool {
        return lhs.id == rhs.id
    }
}
