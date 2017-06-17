class MFUser {
    var id: String!
    var name: String!
    var email: String!
    var address: String?
    var addressLocation: String?
    var picture: String?
    var dishesSoldCount: UInt = 0
    var profileDescription: String?
    
    var cookedDishes: [MFDish:Date] = [:] // dishId:Date
    var boughtDishes: [MFDish:Date] = [:] // dishId:Date
    var favoriteDishes: [MFDish:Date] = [:] // dishId:Date
    var likedDishes: [MFDish:Date] = [:] // dishId:Date
    
    var followers: [MFUser:Date] = [:] // [userId:Date]
    var following: [MFUser:Date] = [:] // [userId:Date]
    var blocked: [MFUser:Date] = [:] // [userId:Date]
    
    var socialAccountIds: [String:String] = [:] // [SocialAccountName:AccountId]
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
