import Foundation

enum MFActivityType: String {
    case liked = "liked"
    case bought = "bought"
    case tipped = "tipped"
    case followed = "followed"
    case started = "started"
    case none = "none"
    
    var text: String {
        switch self {
        case .bought:
            return "bought"
            
        case .followed:
            return "started following"
            
        case .liked:
            return "liked"
            
        case .started:
            return "started live video"
            
        case .tipped:
            return "has tipped"
            
        default:
            return ""
        }
    }
    
    var path: FirebaseReference {
        switch self {
        case .bought,
             .liked,
             .started:
            return FirebaseReference.dishes
            
        case .followed,
             .tipped:
            return FirebaseReference.users
            
        default:
            return FirebaseReference.users
        }
    }
}

struct MFNewsFeed {
    var id: String
    var actionUser: MFUser
    var participantUser: MFUser
    var redirectID: String
    var text: String
    var activity: MFActivityType = .none
    var createdAt: Date
    var mediaURL: URL?
    var likes: [String: Bool] = [String: Bool]()
    var comments: [MFComment] = [MFComment]()
    
    init(with actionUser: MFUser, participantUser: MFUser, activity: MFActivityType, text: String, redirectID: String) {
        self.id = FirebaseReference.newsFeed.generateAutoID()
        self.actionUser = actionUser
        self.participantUser = participantUser
        self.text = text
        self.activity = activity
        self.createdAt = Date.init()
        self.redirectID = redirectID
    }
    
    init(from dictionary:[String: AnyObject]) {
        self.id = dictionary["id"] as? String ?? ""
        
        self.actionUser = MFUser.init()
        self.actionUser.id = dictionary["actionUserID"] as? String ?? ""
        self.actionUser.name = dictionary["actionUserName"] as? String ?? ""
        
        self.participantUser = MFUser()
        self.participantUser.id = dictionary["participantUserID"] as? String ?? ""
        self.participantUser.name = dictionary["participantUserName"] as? String ?? ""
        
        self.text = dictionary["text"] as? String ?? ""
        
        self.createdAt = Date.init(timeIntervalSinceReferenceDate: (dictionary["createdAt"] as? Double) ?? 0)
        self.redirectID = dictionary["redirectID"] as? String ?? ""
        
        if let act = dictionary["activity"] as? String,
            let actEnum = MFActivityType.init(rawValue: act) {
            self.activity = actEnum
        }
        
        self.likes = dictionary["likes"] as? [String: Bool] ?? [:]
        if let commentsArray = dictionary["comments"] as? [String: [String: AnyObject]] {
            for (_, commentDict) in commentsArray {
                let comment = MFComment.init(from: commentDict)
                self.comments.append(comment)
            }
        }
    }
    
}

extension MFNewsFeed: Hashable {
    var hashValue: Int {
        return self.id.hashValue
    }
}

extension MFNewsFeed: Equatable {
    static func ==(lhs: MFNewsFeed, rhs: MFNewsFeed) -> Bool {
        return lhs.id == rhs.id
    }
}
