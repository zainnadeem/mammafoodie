import Foundation


enum MFDishType : String {
    case Veg = "veg"
    case NonVeg = "nonveg"
    case Vegan = "vegan"
    case None = "NA"
}

class MFDish {
    var id: String!
    var name: String!
    var type : MFDishType!
    var user: MFUser!
    var media: MFMedia!
    var description: String?
    var totalSlots: UInt = 0
    var availableSlots: UInt = 0
    var pricePerSlot: Double = 0
    var preparationTime : Double!
    var boughtBy: [MFOrder:Date] = [:]
    var cuisine: MFCuisine!
    
    init(id: String, user: MFUser, description: String, name: String) {
        self.id = id
        self.user = user
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
    
    init(name : String!, description : String?, cuisine : MFCuisine, preparationTime : Double, totalSlots : UInt, withPrice perSlot : Double, dishType : MFDishType, media : MFMedia) {
        self.id = FirebaseReference.dishes.generateAutoID()
        self.name = name
        self.type = dishType
        self.preparationTime = preparationTime
        self.description = description
        self.cuisine = cuisine
        self.totalSlots = totalSlots
        self.pricePerSlot = perSlot
        self.media = media
    }
    
    func save(_ completion : @escaping (Error?) -> Void ) {
        self.media.save { (error) in
            if let er = error {
                completion(error)
            } else {
                DatabaseGateway.sharedInstance.saveDish(self) { (errorDish) in
                    completion(errorDish)
                }
            }
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
