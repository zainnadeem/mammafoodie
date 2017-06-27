import Foundation

class MFUser {
    var id: String!
    var name: String!
    var email: String!
    var address: String?
    var addressLocation: String?
    var picture: String?
    var dishesSoldCount: UInt = 0
    var profileDescription: String?
    
    var userActivity: [MFNewsFeed:Date] = [:]
    var cookedDishes: [MFMedia:Date] = [:] // dishId:Date
    var boughtDishes: [MFMedia:Date] = [:] // dishId:Date
    var favoriteDishes: [MFMedia:Date] = [:] // dishId:Date
    var likedDishes: [MFMedia:Date] = [:] // dishId:Date
    
    var followers: [MFUser:Date] = [:] // [userId:Date]
    var following: [MFUser:Date] = [:] // [userId:Date]
    var blocked: [MFUser:Date] = [:] // [userId:Date]
    
    var socialAccountIds: [String:String] = [:] // [SocialAccountName:AccountId]

    init() {
        
    }

    init(id: String, name: String, picture:String, profileDescription: String) {
        self.id = id
        self.name = name
        self.picture = picture
        self.profileDescription = profileDescription
    }
}

extension MFUser: Hashable {
    var hashValue: Int {
        return self.id.hashValue
    }
}

extension MFUser: Equatable {
    static func ==(lhs: MFUser, rhs: MFUser) -> Bool {
        return lhs.id == rhs.id
    }
}
