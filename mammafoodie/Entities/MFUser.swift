import Foundation

struct MFUserPhone {
    var countryCode: String = ""
    var phone: String = ""
    
    init() {}
    
    func fullString() -> String {
        return self.countryCode + self.phone
    }
}

class MFUser {
    var id: String
    var name: String!
    
    var firstName: String {
        return self.name.components(separatedBy: " ").first ?? ""
    }
    var lastName: String {
        let components = self.name.components(separatedBy: " ")
        if components.count > 1 {
            return components.last ?? ""
        }
        return ""
    }
    
    var email: String!
    var address: String?
    var addressDetails: MFUserAddress?
//    var addressLocation: String?
    //    var addressID:String?
    
    var picture: URL? {
        return DatabaseGateway.sharedInstance.getUserProfilePicturePath(for: self.id)
    }
    
    var dishesSoldCount: UInt = 0
    var profileDescription: String?
    
    var phone: MFUserPhone = MFUserPhone()
    
    //
    //    var userActivity: [MFNewsFeed:Date] = [:]
    //    var cookedDishes: [MFMedia:Date] = [:] // dishId:Date
    //    var boughtDishes: [MFMedia:Date] = [:] // dishId:Date
    //    var favouriteDishes: [MFMedia:Date] = [:] // dishId:Date
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
    //    var favouriteDishes: [String:Bool] = [:] // dishId:Date
    //    var likedDishes: [String:Bool] = [:] // dishId:Date
    //
    //    var followers: [String:Bool] = [:] // [userId:Date]
    //    var following: [String:Bool] = [:] // [userId:Date]
    //    var blocked: [String:Bool] = [:] // [userId:Date]
    
    
    init() {
        self.id = ""
    }
    
    
    init(from Dictionary:[String:AnyObject]) {
        
        self.id = Dictionary["id"] as? String ?? ""
        self.name = Dictionary["name"] as? String ?? ""
//        self.picture = Dictionary["picture"] as? String ?? ""
        self.address = Dictionary["address"] as? String ?? ""
        
        if let rawAddress: [String:AnyObject] = Dictionary["addressDetails"] as? [String:AnyObject] {
            self.addressDetails = self.getAddressDetails(from: rawAddress)
        }
        
//        self.addressLocation = Dictionary["addressLocation"] as? String ?? ""
        self.email = Dictionary["email"] as? String ?? ""
        self.dishesSoldCount = Dictionary["dishesSoldCount"] as? UInt ?? 0
        self.profileDescription = Dictionary["profileDescription"] as? String ?? ""
        
        if let rawPhoneInfo = Dictionary["phone"] as? [String:String] {
            self.phone.countryCode = rawPhoneInfo["countryCode"] ?? ""
            self.phone.phone = rawPhoneInfo["phone"] ?? ""
        }
        
        //        self.socialAccountIds = Dictionary["socialAccountIds"] as? [String:String] ?? [:]
        //        self.userActivity = Dictionary["userActivity"] as? [String:Bool] ?? [:]
        //        self.cookedDishes = Dictionary["cookedDishes"] as? [String:Bool] ?? [:]
        //        self.boughtDishes = Dictionary["boughtDishes"] as? [String:Bool] ?? [:]
        //        self.favouriteDishes = Dictionary["favouriteDishes"] as? [String:Bool] ?? [:]
        //        self.likedDishes = Dictionary["likedDished"] as? [String:Bool] ?? [:]
        //        self.following = Dictionary["following"] as? [String:Bool] ?? [:]
        //        self.followers = Dictionary["followers"]  as? [String:Bool] ?? [:]
        //        self.blocked = Dictionary["blocked"] as? [String:Bool] ?? [:]
    }
    
    init(id: String, name: String, picture:String, profileDescription: String) {
        self.id = id
        self.name = name
//        self.picture = picture
        self.profileDescription = profileDescription
    }
    
    init(id: String, name: String, picture:String, profileDescription: String, email:String) {
        self.id = id
        self.name = name
//        self.picture = picture
        self.profileDescription = profileDescription
        self.email = email
    }
    
    func getAddressDetails(from rawAddress: [String:AnyObject]) -> MFUserAddress {
        var address: MFUserAddress = MFUserAddress()
        
        address.id = rawAddress["id"] as? String ?? ""
        address.address = rawAddress["address"] as? String ?? ""
        address.address_2 = rawAddress["address_2"] as? String ?? ""
        address.city = rawAddress["city"]  as? String ?? ""
        address.state = rawAddress["state"] as? String ?? ""
        address.postalCode = rawAddress["postalCode"] as? String ?? ""
        address.latitude = rawAddress["latitude"] as? String ?? ""
        address.longitude = rawAddress["longitude"] as? String ?? ""
        address.country = "US"
        
        return address
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
