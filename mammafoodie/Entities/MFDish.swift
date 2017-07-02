

import Foundation


enum MFDishMediaType : String {
    case liveVideo = "liveVideo"
    case vidup = "vidup"
    case picture = "picture"
    case unknown = "unknown"
}

enum MediaAccessUserType {
    case owner
    case viewer
}


enum MFDishType : String {
    case Veg = "veg"
    case NonVeg = "nonveg"
    case Vegan = "vegan"
    case None = "NA"
}

class MFDish {
    var id: String!
    var name: String!

    var dishType : MFDishType!
    var user: MFUser!
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
    
    var likesCount : Double = 0
    var commentsCount : Double = 0
    
    var createdAt: Date!
    var endedAt: Date!
    var mediaType: MFDishMediaType = .unknown
    var mediaURL : URL!
    
    var accessMode: MediaAccessUserType = .viewer
    
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
        self.type = dishType
        
    }
    
    init(name : String!, description : String?, cuisine : MFCuisine, dishType : MFDishType, mediaType : MFDishMediaType) {
      self.id = FirebaseReference.dishes.generateAutoID()
        self.name = name
        self.dishType = dishType
        self.description = description
        self.cuisine = cuisine
        self.mediaType = mediaType
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
            self.type = dishType
        } else {
            self.type = .None
        }
        
    }

    func save(_ completion : @escaping (Error?) -> Void ) {
        DatabaseGateway.sharedInstance.saveDish(self) { (errorDish) in
            completion(errorDish)
        }
    }
    
    func generateCoverImageURL() -> URL {
        let urlencodedID : String! = (self.id.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))!
        let string = "https://firebasestorage.googleapis.com/v0/b/mammafoodie-baf82.appspot.com/o/dish%2Fcover%2F\(urlencodedID!).jpg?alt=media"
        return URL.init(string: string)!
    }
    
    func generateCoverThumbImageURL() -> URL {
        let urlencodedID : String! = (self.id.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))!
        let string = "https://firebasestorage.googleapis.com/v0/b/mammafoodie-baf82.appspot.com/o/dish%2Fcover%2F\(urlencodedID!)).jpg?alt=media"
        return URL.init(string: string)!
    }
    
    func getStoragePath() -> String {
        var urlencodedID : String! = ""
        if let idEncoded = self.id.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            if self.mediaType == .picture    {
                urlencodedID = "\(idEncoded).jpg"
            } else if self.mediaType == .vidup {
                urlencodedID = "\(idEncoded).mp4"
            }
        }
        return "/dishes/\(urlencodedID!)"
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
