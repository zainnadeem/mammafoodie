import Foundation

class MFUser {
    var id: String!
    var name: String!
    var email: String!
//    var address: String?
//    var addressLocation: String?
//    var addressID:String?
    var picture: String?
    var dishesSoldCount: UInt = 0
    var profileDescription: String?
    var phone:String!
//    
//    var userActivity: [MFNewsFeed:Date] = [:]
//    var cookedDishes: [MFMedia:Date] = [:] // dishId:Date
//    var boughtDishes: [MFMedia:Date] = [:] // dishId:Date
//    var favoriteDishes: [MFMedia:Date] = [:] // dishId:Date
//    var likedDishes: [MFMedia:Date] = [:] // dishId:Date
//    
//    var followers: [MFUser:Date] = [:] // [userId:Date]
//    var following: [MFUser:Date] = [:] // [userId:Date]
//    var blocked: [MFUser:Date] = [:] // [userId:Date]
//    
//    var socialAccountIds: [String:String] = [:] // [SocialAccountName:AccountId]
    
    
    
//    var userActivity: [String:Bool] = [:]   //[MFNewsFeed.id : true]
//    var cookedDishes: [String:Bool] = [:] // dishId:Date
//    var boughtDishes: [String:Bool] = [:] // dishId:Date
//    var favoriteDishes: [String:Bool] = [:] // dishId:Date
//    var likedDishes: [String:Bool] = [:] // dishId:Date
//    
//    var followers: [String:Bool] = [:] // [userId:Date]
//    var following: [String:Bool] = [:] // [userId:Date]
//    var blocked: [String:Bool] = [:] // [userId:Date]
    
   
    init() {
        
    }

    
    init(from Dictionary:[String:AnyObject]){
        
        self.id = Dictionary["id"] as? String ?? ""
        self.name = Dictionary["name"] as? String ?? ""
        self.picture = Dictionary["picture"] as? String ?? ""
//        self.address = Dictionary["addressID"] as? String ?? ""
//        self.addressLocation = Dictionary["addressLocation"] as? String ?? ""
        self.email = Dictionary["email"] as? String ?? ""
        self.dishesSoldCount = Dictionary["dishesSoldCount"] as? UInt ?? 0
        self.profileDescription = Dictionary["profileDescription"] as? String ?? ""
        self.phone = Dictionary["phone"] as? String ?? ""
        
//        self.socialAccountIds = Dictionary["socialAccountIds"] as? [String:String] ?? [:]
//        self.userActivity = Dictionary["userActivity"] as? [String:Bool] ?? [:]
//        self.cookedDishes = Dictionary["cookedDishes"] as? [String:Bool] ?? [:]
//        self.boughtDishes = Dictionary["boughtDishes"] as? [String:Bool] ?? [:]
//        self.favoriteDishes = Dictionary["favouriteDishes"] as? [String:Bool] ?? [:]
//        self.likedDishes = Dictionary["likedDished"] as? [String:Bool] ?? [:]
//        self.following = Dictionary["following"] as? [String:Bool] ?? [:]
//        self.followers = Dictionary["followers"]  as? [String:Bool] ?? [:]
//        self.blocked = Dictionary["blocked"] as? [String:Bool] ?? [:]
    }

    init(id: String, name: String, picture:String, profileDescription: String) {
        self.id = id
        self.name = name
        self.picture = picture
        self.profileDescription = profileDescription
    }
    
    init(id: String, name: String, picture:String, profileDescription: String, email:String) {
        self.id = id
        self.name = name
        self.picture = picture
        self.profileDescription = profileDescription
        self.email = email
    }
    
    func generateProfilePictureURL() -> URL {
        let urlencodedID : String! = (self.id.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))!
        let string = "https://firebasestorage.googleapis.com/v0/b/mammafoodie-baf82.appspot.com/o/user%2Fprofile%2F\(urlencodedID!).jpg?alt=media"
        return URL.init(string: string)!
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
