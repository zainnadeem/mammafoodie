class MFDish {
    var id: String!
    var name: String!
    var chefID: String! //MFUser id
    var mediaID: String?  //MFMedia id
    var description: String?
    var totalSlots: UInt = 0
    var availableSlots: UInt = 0
    var pricePerSlot: Double = 0
    var boughtOrders: [String:Date] = [:] //MFOrder id
    var cuisineID: String! //MFCusine id
    
    init(id: String, user: MFUser, description: String, name: String) {
        self.id = id
        self.user = user
        self.description = description
        self.name = name
    }
    
    init(id: String, name: String, chefID: String, description: String,  cuisineID:String, totalSlots:UInt, availableSlots:UInt, pricePerSlot:Double, boughtOrders:[String:Date], mediaID:String) {
        self.id = id
        self.chefID = chefID
        self.description = description
        self.name = name
        self.cuisineID = cuisineID
        self.totalSlots = totalSlots
        self.availableSlots = availableSlots
        self.pricePerSlot = pricePerSlot
        self.boughtOrders = boughtOrders
        self.mediaID = mediaID
        
    }
    
    init(from dishDataDictionary:[String:AnyObject]){
        self.id = dishDataDictionary["id"] as? String ?? ""
        self.name = dishDataDictionary["name"] as? String ?? ""
        self.chefID = dishDataDictionary["chefID"]   as? String ?? ""
        self.mediaID = dishDataDictionary["mediaID"] as? String ?? ""
        self.description = dishDataDictionary["description"]  as? String ?? ""
        self.totalSlots = dishDataDictionary["totalSlots"] as? UInt ?? 0
        self.availableSlots = dishDataDictionary["availableSlots"] as? UInt ?? 0
        self.pricePerSlot = dishDataDictionary["pricePerSlot"]  as? Double ?? 0
        self.boughtOrders = dishDataDictionary["boughtOrders"]  as? [String:Date] ?? [:]
        self.cuisineID = dishDataDictionary["cuisineID"] as? String ?? ""
        
    }
    
}

extension MFDish: Hashable {
    var hashValue: Int {
        return self.id.hashValue
    }
}

extension MFDish: Equatable {
    static func ==(lhs: MFDish, rhs: MFDish) -> Bool {
        return lhs.id == rhs.id
    }
}
