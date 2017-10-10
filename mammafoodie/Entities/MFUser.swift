import Foundation

struct MFUserPhone {
    var countryCode: String = ""
    var phone: String = ""
    
    init() {}
    
    func fullString() -> String {
        return self.countryCode + self.phone
    }
}

struct StripeVerification {
    var isStripeAccountVerified: Bool = false
    var submittedForStripeVerification: Bool = false
    var dueBy: Date?
    var disabledReason: String?
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
    
    var stripeVerification: StripeVerification?
    
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
        
        self.stripeVerification = MFUser.stripeVerification(from: Dictionary)
        
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
    
    class func stripeVerification(from raw: [String:Any]) -> StripeVerification? {
        if let stripeVerificationDictionary: [String:Any] = raw["stripeVerification"] as? [String:Any] {
            var stripeVerification: StripeVerification = StripeVerification()
            
            if let isVerified: Bool = stripeVerificationDictionary["isStripeAccountVerified"] as? Bool {
                stripeVerification.isStripeAccountVerified = isVerified
            }
            if let submittedForStripeVerification: Bool = stripeVerificationDictionary["submittedForStripeVerification"] as? Bool {
                stripeVerification.submittedForStripeVerification = submittedForStripeVerification
            }
            if let dueByTimestamp: Double = stripeVerificationDictionary["due_by"] as? Double {
                stripeVerification.dueBy = Date.init(timeIntervalSince1970: dueByTimestamp)
            }
            if let disabledReason: String = stripeVerificationDictionary["disabled_reason"] as? String {
                stripeVerification.disabledReason = disabledReason
            }
            return stripeVerification
        }
        return nil
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
