class MFDish {
    var id: String!
    var user: MFUser!
    var media: MFMedia?
    var description: String?
    var totalSlots: UInt = 0
    var availableSlots: UInt = 0
    var pricePerSlot: Double = 0
    var boughtBy: [MFOrder:Date] = [:]
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
