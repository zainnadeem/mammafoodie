import Foundation

enum MFOrderStatus: String {
    case pending = "pending"
    case beingPrepared = "beingPrepared"
    case ready = "ready"
    case cancelled = "cancelled"
    case inTransit = "inTransit"
    case delivered = "delivered"
    case pickedUP = "pickedUP"
}

enum MFShippingMethod: String {
    case pickup = "pickUP"
    case delivery = "delivery"
}

//struct MFShippingAddress {
//    var address: String!
//    var location: String!
//}

enum MFDeliveryOption: String {
    case uberEATS = "UberEATS"
    case postmates = "Postmates"
}

enum MFPaymentMethod: String {
    case stripe = "stripe"
}

class MFOrder {
    var id: String!
    var dish: MFDish!
    var quantity: UInt = 0
    var boughtBy: MFUser!
    var status: MFOrderStatus = .pending
    var createdAt: Date!
    var shippingMethod: MFShippingMethod!
    var shippingAddress: MFUserAddress!
    var deliveryId: String?
    var deliveryOption: MFDeliveryOption?
    var paymentMethod: MFPaymentMethod!
    var paymentDetails: MFPaymentDetails!
    
//    init(from orderDataDictionary:[String:AnyObject]) {
//        var Dishid = orderDataDictionary["dishId"] as? String ?? ""
//        var quantity = orderDataDictionary["quantity"] as? String ?? ""
//    }
    
//    init(quantity: UInt, buyer: MFUser, dish: MFDish, paymentDetails: MFPaymentDetails, paymentMethod: MFPaymentMethod) {
//        self.id = FirebaseReference.orders.generateAutoID()
//        self.dish = dish
//        self.boughtBy = buyer
//        self.status = .pending
//        self.createdAt = Date.init()
//        self.paymentDetails = paymentDetails
//        self.paymentMethod = paymentMethod
//    }
}

extension MFOrder: Hashable {
    var hashValue: Int {
        return self.id.hashValue
    }
}

extension MFOrder: Equatable {
    static func ==(lhs: MFOrder, rhs: MFOrder) -> Bool {
        return lhs.id == rhs.id
    }
}
