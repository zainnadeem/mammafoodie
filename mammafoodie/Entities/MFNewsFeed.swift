import Foundation

enum MFNewsFeedRedirectPath: String {
    case dish = "Dishes"
    case user = "Users"
    case unknown
}

enum MFActivityType: String {
    case liked = "liked"
    case bought = "bought"
    case tipped = "tipped"
    case followed = "followed"
    case started = "started"
    case none = "none"
}

struct MFNewsFeed {
    var id: String
    var actionUser: MFUser
    var participantUser: MFUser
    var redirectID: String
    var redirectPath: MFNewsFeedRedirectPath = .unknown
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
        
        switch self.activity {
        case .bought, .liked, .started:
            self.redirectPath =  MFNewsFeedRedirectPath.dish
        case .followed, .tipped:
            self.redirectPath = .user
        default:
            self.redirectPath = .unknown
        }
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
        if let redirectPath = dictionary["redirectPath"] as? String,
            let pathEnum = MFNewsFeedRedirectPath(rawValue:redirectPath) {
            self.redirectPath = pathEnum
        } else {
            self.redirectPath = .unknown
        }
        
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
