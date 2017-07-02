

import Foundation


enum MFDishType : String {
    case Veg = "veg"
    case NonVeg = "nonveg"
    case Vegan = "vegan"
    case None = "NA"
}

enum MFDishMediaType: String {
    case liveVideo = "liveVideo"
    case vidup = "vidup"
    case picture = "picture"
    case undefined = "undefined"
}

enum MFDishMediaAccessMode {
    case owner
    case viewer
}

class MFDish {
    var id: String!
    var name: String!
    var mediaID: String?  //MFMedia id
    
    var dishType : MFDishType!
    var user: MFUser!
    var media: MFMedia!
    
    var description: String?
    var totalSlots: UInt = 0
    var availableSlots: UInt = 0
    var pricePerSlot: Double = 0
    
    var boughtOrders: [String:Date] = [:] //MFOrder id
    var cuisineID: String! //MFCusine id
    var tag:String!
    
    
    var preparationTime : Double!
    var boughtBy: [MFOrder:Date] = [:]
    var cuisine: MFCuisine!
    
    var likesCount: UInt = 0
    var commentsCount: UInt = 0
    var createTimestamp: TimeInterval = 0
    var endTimestamp: TimeInterval = 0
    var mediaType: MFDishMediaType = MFDishMediaType.undefined
    var mediaURL: URL?
    var accessMode: MFDishMediaAccessMode = MFDishMediaAccessMode.viewer
    
    init() {}
    
    init(id: String, user: MFUser, description: String, name: String) {
        self.id = id
//        self.user = user
        self.description = description
        self.name = name
    }
    
    init(id: String, name: String, userID: String, description: String,  cuisineID:String, totalSlots:UInt, availableSlots:UInt, pricePerSlot:Double, boughtOrders:[String:Date], mediaID:String, tag:String, dishType:MFDishType) {
        self.id = id
        
        self.user = MFUser() ; user.id = userID
        
        self.description = description
        self.name = name
        self.cuisineID = cuisineID
        self.totalSlots = totalSlots
        self.availableSlots = availableSlots
        self.pricePerSlot = pricePerSlot
        self.boughtOrders = boughtOrders
        self.mediaID = mediaID
        self.tag = tag
        self.dishType = dishType
        
    }
    
    
    init(from dishDataDictionary:[String:AnyObject]){
        self.id = dishDataDictionary["id"] as? String ?? ""
        self.name = dishDataDictionary["name"] as? String ?? ""
        
        let userID = dishDataDictionary["userID"]   as? String ?? ""
        self.user = MFUser() ; user.id = userID
        
        self.mediaID = dishDataDictionary["mediaID"] as? String ?? ""
        self.description = dishDataDictionary["description"]  as? String ?? ""
        self.totalSlots = dishDataDictionary["totalSlots"] as? UInt ?? 0
        self.availableSlots = dishDataDictionary["availableSlots"] as? UInt ?? 0
        self.pricePerSlot = dishDataDictionary["pricePerSlot"]  as? Double ?? 0
        self.boughtOrders = dishDataDictionary["boughtOrders"]  as? [String:Date] ?? [:]
        self.cuisineID = dishDataDictionary["cuisineID"] as? String ?? ""
        self.tag = dishDataDictionary["tag"] as? String ?? ""
        
        let dishType = dishDataDictionary["dishType"] as? String ?? ""
        
        if let dishType = MFDishType(rawValue: dishType){
            self.dishType = dishType
        } else {
            self.dishType = .None
        }
        
    }
    init(name : String!, description : String?, cuisine : MFCuisine, preparationTime : Double, totalSlots : UInt, withPrice perSlot : Double, dishType : MFDishType, media : MFMedia) {
        self.id = FirebaseReference.dishes.generateAutoID()
        self.name = name
        self.dishType = dishType
        self.preparationTime = preparationTime
        self.description = description
        self.cuisine = cuisine
        self.totalSlots = totalSlots
        self.pricePerSlot = perSlot
        self.media = media
    }
    
    func save() {
        DatabaseGateway.sharedInstance.saveDish(self) { (error) in
            print(error?.localizedDescription ?? "No Error")
        }
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
