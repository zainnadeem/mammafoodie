import Foundation

enum MFNewsFeedRedirectPath:String {
    case dish
    case unknown
}

struct MFNewsFeed {
    var id: String!
    var actionUserID: String!
    var redirectID: String!
    var redirectPath: MFNewsFeedRedirectPath? = .unknown
    var participantUserID: String!
    var activityID: String!
    var text: String!
    var attributedString: NSMutableAttributedString?
    var liked: [String:Bool] = [:] //MFUser id
    var comments: [String:Bool] = [:] //MFComments id
    
    init() {
        
    }
    
    init(id: String!, actionUserId: String, participantUserId: String, activity: MFActivity, text: NSMutableAttributedString){
        self.id = id
        self.actionUserID = actionUserId
        self.participantUserID = participantUserId
        self.attributedString = text
//        self.activity = activity
    }
    
    init(from dictionary:[String:AnyObject]){
        
        self.id = dictionary["id"] as? String ?? ""
        self.actionUserID = dictionary["actionUserID"] as? String ?? ""
        self.redirectID = dictionary["redirectID"] as? String ?? ""
        
        let redirectPath = dictionary["redirectPath"] as? String ?? ""
        
        if let redirectPath = MFNewsFeedRedirectPath(rawValue:redirectPath){
            self.redirectPath = redirectPath
        } else {
            self.redirectPath = .unknown
        }
        
        self.participantUserID = dictionary["participantUserID"] as? String ?? ""
        self.activityID = dictionary["activityID"] as? String ?? ""
        self.text = dictionary["text"] as? String ?? ""
//        self.attributedString = dictionary[]
        
        self.liked = dictionary["liked"] as? [String:Bool] ?? [:]
        self.comments = dictionary["comments"] as? [String:Bool] ?? [:]
        
        
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
