enum MFMediaType {
    case liveVideo
    case vidup
    case picture
    case unknown
}

enum MediaAccessUserType {
    case owner
    case viewer
}

struct MFMedia {
    var id: String!
    var comments: [Date:MFComment] = [:] // date:commentId
    var contentId: String!
    var cover_large: String?
    var cover_small: String?
    var createdAt: Date!
    var endedAt: Date?
    var dish: MFDish!
    var likes: [Date:MFUser] = [:] // date:userId
    var numberOfViewers: UInt = 0
    var type: MFMediaType = .unknown
    var user: MFUser?
    
    var accessMode: MediaAccessUserType = .viewer
    
    init() {
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
