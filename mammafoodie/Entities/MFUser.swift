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
    
    enum VerificationFields: String {
        case externalAccount = "external_account"
        case dobDay = "legal_entity.dob.day"
        case dobMonth = "legal_entity.dob.month"
        case dobYear = "legal_entity.dob.year"
        case firstName = "legal_entity.first_name"
        case lastName = "legal_entity.last_name"
        case accountType = "legal_entity.type"
        case tosDate = "tos_acceptance.date"
        case tosIP = "tos_acceptance.ip"
        case document = "document"
        case address = "legal_entity.address.line1"
        case postal = "legal_entity.address.postal_code"
        case city = "legal_entity.address.city"
        case state = "legal_entity.address.state"
        case ssnLast4 = "legal_entity.ssn_last_4"
        case ssnFull = "legal_entity.personal_id_number"
    }
    
    var isStripeAccountVerified: Bool = false
    var submittedForStripeVerification: Bool = false
    var dueBy: Date?
    var disabledReason: String?
    var fields_needed: [String] = []
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
    var address: String = ""
    var addressDetails: MFUserAddress?
    //    var addressLocation: String?
    //    var addressID:String?
    var picture: URL? {
        return DatabaseGateway.sharedInstance.getUserProfilePicturePath(for: self.id)
    }
    var dishesSoldCount: UInt = 0
    var profileDescription: String?
    var phone: MFUserPhone = MFUserPhone()
    var stripeChargesEnabled: Bool = false
    var stripePayoutsEnabled: Bool = false
    var stripeVerification: StripeVerification?
    var searchTags: [String: String] = [String: String]()
    
    init() {
        self.id = ""
        self.email = ""
        self.dishesSoldCount = 0
        self.profileDescription = ""
    }
    
    
    init(from Dictionary:[String:AnyObject]) {
        
        if let userid = Dictionary["id"] as? String {
            self.id = userid
        } else {
            if let userid = Dictionary["uid"] as? String {
                self.id = userid
            } else {
                self.id = ""
                print("Error in User ID")
            }
            
        }
        
        self.name = Dictionary["name"] as? String ?? ""
        if  let add = Dictionary["address"] as? String {
            self.address = add
        }
        self.email = Dictionary["email"] as? String ?? ""
        self.dishesSoldCount = Dictionary["dishesSoldCount"] as? UInt ?? 0
        self.profileDescription = Dictionary["profileDescription"] as? String ?? ""
        self.stripeVerification = MFUser.stripeVerification(from: Dictionary)
        
        if let rawSearchTags = Dictionary["searchTags"] as? [String: String] {
            self.searchTags = rawSearchTags
        }
        
        if let rawAddress: [String:AnyObject] = Dictionary["addressDetails"] as? [String:AnyObject] {
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
            self.addressDetails = address
        }
        if let rawPhoneInfo = Dictionary["phone"] as? [String:String] {
            self.phone.countryCode = rawPhoneInfo["countryCode"] ?? ""
            self.phone.phone = rawPhoneInfo["phone"] ?? ""
        }
        
        if let rawStripe = Dictionary["stripe"] as? [String:Any] {
            self.stripeChargesEnabled = rawStripe["charges_enabled"] as? Bool ?? false
            self.stripePayoutsEnabled = rawStripe["payouts_enabled"] as? Bool ?? false
        }
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
            if let fields_needed: [String] = stripeVerificationDictionary["fields_needed"] as? [String] {
                stripeVerification.fields_needed = fields_needed
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
