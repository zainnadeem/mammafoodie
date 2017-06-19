class MFDish {
    var id: String!
    var name: String!
    var user: MFUser!
    var media: MFMedia?
    var description: String?
    var totalSlots: UInt = 0
    var availableSlots: UInt = 0
    var pricePerSlot: Double = 0
    var boughtBy: [MFOrder:Date] = [:]
    
    init(id: String, user: MFUser, description: String, name: String) {
        self.id = id
        self.user = user
        self.description = description
        self.name = name
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
