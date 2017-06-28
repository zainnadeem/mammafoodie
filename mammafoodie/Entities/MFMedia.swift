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
    var comments: [String:Bool] = [:] //MFComment id
    var contentID: String!
    var cover_large: String?
    var cover_small: String?
    var createdAt: String! //Date timestamp
    var endedAt: String! //Date timestamp
    var dishID: String! //MFDish id
    var likes: [String:Bool] = [:] //MFUser id
    var numberOfViewers: UInt = 0
    var type: MFMediaType = .unknown
    var chefID: String! //MFUser id
    
    
    var accessMode: MediaAccessUserType = .viewer
    
    init() {
        
    }
    
    init(id: String, cover_large: String, cover_small: String, createdAt: String, dishID: String, chefID: String, type: MFMediaType, numberOfViewers: UInt) {
        self.id = id
        self.cover_large = cover_large
        self.cover_small = cover_small
        self.createdAt = createdAt
        self.dishID = dishID
        self.chefID = chefID
        self.type = type
        self.numberOfViewers = numberOfViewers
    }
    
    init(from mediaDictionary:[String:AnyObject]) {
        
        self.id = mediaDictionary["id"] as? String ?? ""
        self.comments = mediaDictionary["comments"] as? [String:Bool] ?? [:]
        self.contentID = mediaDictionary["contentID"] as? String ?? ""
        self.cover_large = mediaDictionary["cover_large"] as? String ?? ""
        self.cover_small = mediaDictionary["cover_small"] as? String ?? ""
        self.createdAt = mediaDictionary["createdAt"] as? String ?? ""
        self.endedAt = mediaDictionary["endedAt"] as? String ?? ""
        self.dishID = mediaDictionary["dishID"] as? String ?? ""
        self.likes = mediaDictionary["likes"] as? [String:Bool] ?? [:]
        self.numberOfViewers = mediaDictionary["numberOfViewers"] as? UInt ?? 0
        
        let type = mediaDictionary["type"] as? String ?? ""
        
        if let type = MFMediaType(rawValue: type) {
            self.type = type
        } else {
            self.type = .unknown
        }
        
        self.chefID = mediaDictionary["chefID"] as? String ?? ""
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
