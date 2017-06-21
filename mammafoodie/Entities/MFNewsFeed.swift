import Foundation

struct MFNewsFeed {
    var id: String!
    var actionUserId: MFUser!
    var redirectId: String?
    var redirectPath: String?
    var participantUserId: MFUser?
    var activityId: MFActivity!
    var text: String!
    var attributedString: NSMutableAttributedString!
    var liked: [MFUser:Date] = [:]
    var comments: [MFComment:Date] = [:]
    
    init(id: String!, actionUserId: MFUser, participantUserId: MFUser, activityID: MFActivity, text: NSMutableAttributedString){
        self.id = id
        self.actionUserId = actionUserId
        self.participantUserId = participantUserId
        self.attributedString = text
        
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
