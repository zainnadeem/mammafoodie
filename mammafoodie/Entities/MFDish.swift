import Foundation
import MapKit

enum MFDishMediaType : String {
    case liveVideo = "liveVideo"
    case vidup = "vidup"
    case picture = "picture"
    case unknown = "unknown"
}

enum MFDishType : String {
    case Veg = "veg"
    case NonVeg = "nonveg"
    case Vegan = "vegan"
    case None = "NA"
}

enum MFDishMediaAccessMode {
    case owner
    case viewer
}

class MFDish {
    
    var id: String
    var name: String
    
    var dishType : MFDishType = .None
    var user: MFUser!
    var username: String!
    
    var description: String?
    var totalSlots: UInt = 0
    var availableSlots: UInt = 0
    var pricePerSlot: Double = 0
    var numberOfViewers: UInt = 0
    var nonUniqueViewersCount: UInt = 0
    
    var numberOfComments: UInt = 0
    var numberOfLikes: UInt = 0
    
    var boughtOrders: [String:Date] = [:] //MFOrder id
    var tag:String!
    
    var createTimestamp: Date!
    var endTimestamp: Date?
    
    var preparationTime : Double = 0
    var boughtBy: [MFOrder: Date] = [:]
    var cuisine: MFCuisine!
    
    var mediaType: MFDishMediaType = MFDishMediaType.unknown
    var mediaURL: URL?
    var accessMode: MFDishMediaAccessMode = MFDishMediaAccessMode.viewer
    
    var coverPicURL:URL?
    
    var likesCount : Double = 0
    var commentsCount : Double = 0
    var totalOrders: Double = 0
    
    var location : CLLocationCoordinate2D?
    var address : String = ""
    var searchTags: [String: String] = [String: String]()
    
    init() {
        self.id = ""
        self.name = ""
    }
    
    init(id: String, description: String, name: String) {
        self.id = id
        //        self.user = user
        self.description = description
        self.name = name
    }
    
    init(id: String, user: MFUser, description: String, name: String, cuisine: MFCuisine) {
        self.id = id
        self.user = user
        self.description = description
        self.name = name
        self.cuisine = cuisine
    }
    
    init(id: String, name: String, userID: String, description: String,  cuisineID:String, totalSlots:UInt, availableSlots:UInt, pricePerSlot:Double, boughtOrders:[String:Date], mediaID:String, tag:String, dishType:MFDishType) {
        self.id = id
        self.user = MFUser() ; user.id = userID
        self.description = description
        self.name = name
        self.cuisine = MFCuisine.init(with: ["id" : cuisineID as AnyObject])
        self.totalSlots = totalSlots
        self.availableSlots = availableSlots
        self.pricePerSlot = pricePerSlot
        self.boughtOrders = boughtOrders
        self.tag = tag
        self.dishType = dishType
        
    }
    
    init(name : String!, description : String?, cuisine : MFCuisine, dishType : MFDishType, mediaType : MFDishMediaType) {
        self.id = FirebaseReference.dishes.generateAutoID()
        self.name = name
        self.dishType = dishType
        self.description = description
        self.cuisine = cuisine
        self.mediaType = mediaType
    }
    
    init(from dishDataDictionary:[String:AnyObject]) {
        self.id = dishDataDictionary["id"] as? String ?? ""
        self.name = dishDataDictionary["name"] as? String ?? ""
        
        if let userDict = dishDataDictionary["user"] as? [String: AnyObject] {
            self.user = MFUser(from: userDict)
        }
        
        if let rawDishMediaType = dishDataDictionary["mediaType"] as? String {
            if let dishMediaType: MFDishMediaType = MFDishMediaType(rawValue: rawDishMediaType) {
                self.mediaType = dishMediaType
            } else {
                print("Dish media type not found: \(self.id)")
            }
        } else {
            print("Dish media type not found: \(self.id)")
        }
        
        if let rawSearchTags = dishDataDictionary["searchTags"] as? [String: String] {
            self.searchTags = rawSearchTags
        }
        
        self.numberOfComments = dishDataDictionary["commentsCount"] as? UInt ?? 0
        self.numberOfLikes = dishDataDictionary["likesCount"] as? UInt ?? 0
        
        let creationTimestamp: TimeInterval = dishDataDictionary["createTimestamp"] as! TimeInterval
        self.createTimestamp = Date.init(timeIntervalSinceReferenceDate: creationTimestamp)
        
        if let endingTimestamp: TimeInterval = dishDataDictionary["endTimestamp"] as? TimeInterval {
            self.endTimestamp = Date.init(timeIntervalSinceReferenceDate: endingTimestamp)
        }
        
        self.mediaURL = dishDataDictionary["mediaURL"] as? URL ?? nil
        self.coverPicURL = dishDataDictionary["coverPicURL"] as? URL ?? nil
        
        let user = dishDataDictionary["user"]   as? [String:AnyObject] ?? [:]
        self.user = MFUser() ;
        
        self.user.id = user["id"] as? String ?? ""
        self.user.name = user["name"] as? String ?? ""
        
        if let endTime = dishDataDictionary["endTimestamp"] as? Double {
            self.endTimestamp = Date.init(timeIntervalSinceReferenceDate: endTime)
        }
        
        self.description = dishDataDictionary["description"]  as? String ?? ""
        self.totalSlots = dishDataDictionary["totalSlots"] as? UInt ?? 0
        self.availableSlots = dishDataDictionary["availableSlots"] as? UInt ?? 0
        self.pricePerSlot = dishDataDictionary["pricePerSlot"]  as? Double ?? 0
        self.boughtOrders = dishDataDictionary["boughtOrders"]  as? [String:Date] ?? [:]
        
        self.tag = dishDataDictionary["tag"] as? String ?? ""
        self.tag = dishDataDictionary["tag"] as? String ?? ""
        
        let dishType = dishDataDictionary["dishType"] as? String ?? ""
        
        if let dishType = MFDishType(rawValue: dishType){
            self.dishType = dishType
        } else {
            self.dishType = .None
        }
        
        let urlString = dishDataDictionary["mediaURL"] as? String ?? ""
        if let url = URL(string: urlString){
            self.mediaURL = url
        }
        
        self.numberOfViewers = dishDataDictionary["numberOfViews"] as? UInt ?? 0
        
        if let rawCuisine = dishDataDictionary["cuisine"] as? [String : AnyObject] {
            self.cuisine = MFCuisine.init(with: rawCuisine)
        }
        
        if let rawLocation = dishDataDictionary["location"] as? [String : AnyObject] {
            let lat = rawLocation["latitude"] as! CLLocationDegrees
            let lon = rawLocation["longitude"] as! CLLocationDegrees
            self.location = CLLocationCoordinate2D.init(latitude: lat, longitude: lon)
            self.address = rawLocation["address"] as? String ?? ""
        }
        
    }
    
    init(name : String!, description : String?, cuisine : MFCuisine, preparationTime : Double, totalSlots : UInt, withPrice perSlot : Double, dishType : MFDishType) {
        self.id = FirebaseReference.dishes.generateAutoID()
        self.name = name
        self.dishType = dishType
        self.preparationTime = preparationTime
        self.description = description
        self.cuisine = cuisine
        self.totalSlots = totalSlots
        self.pricePerSlot = perSlot
    }
    
    func save(_ completion : @escaping (Error?) -> Void ) {
        DatabaseGateway.sharedInstance.saveDish(self) { (errorDish) in
            completion(errorDish)
        }
    }
    
//    func generateCoverImageURL() -> URL {
//        let urlencodedID : String! = (self.id.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))!
//        let string = "https://firebasestorage.googleapis.com/v0/b/mammafoodie-baf82.appspot.com/o/dishes%2Fcover%2F\(urlencodedID!).jpg?alt=media"
//        return URL.init(string: string)!
//    }
//    
//    func generateCoverThumbImageURL() -> URL {
//        let urlencodedID : String! = (self.id.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))!
//        let string = "https://firebasestorage.googleapis.com/v0/b/mammafoodie-baf82.appspot.com/o/dishes%2Fcover%2F\(urlencodedID!).jpg?alt=media"
//        return URL.init(string: string)!
//    }
    
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
    
    func getThumbPath() -> String {
        var urlencodedID : String = ""
        if let idEncoded = self.id.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            urlencodedID = "\(idEncoded).jpg"
        }
        return "/dishes/thumbs/\(urlencodedID)"
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
