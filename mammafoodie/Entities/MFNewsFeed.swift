import Foundation

enum MFNewsFeedRedirectPath {
    case dish
    case unknown
}

struct MFNewsFeed {
    var id: String!
    var actionUserId: MFUser!
    var redirectId: String?
    var redirectPath: MFNewsFeedRedirectPath? = .unknown
    var participantUserId: MFUser?
    var activity: MFActivity!
    var text: String!
    var attributedString: NSMutableAttributedString!
    var liked: [MFUser:Date] = [:]
    var comments: [MFComment:Date] = [:]
    
    init() {
        
    }
    
    init(id: String!, actionUserId: MFUser, participantUserId: MFUser, activity: MFActivity, text: NSMutableAttributedString){
        self.id = id
        self.actionUserId = actionUserId
        self.participantUserId = participantUserId
        self.attributedString = text
        self.activity = activity
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
