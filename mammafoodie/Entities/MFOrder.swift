import Foundation

enum MFOrderStatus {
    case pending
    case beingPrepared
    case ready
    case cancelled
    case inTransit
    case delivered
    case pickedUp
}

enum MFShippingMethod {
    case pickup
    case delivery
}

struct MFShippingAddress {
    var address: String!
    var location: String!
}

enum MFDeliveryOption: String {
    case uberRush = "UberRush"
    case postmate = "Postmate"
}

enum MFPaymentMethod {
    case stripe
}

class MFOrder {
    var id: String!
    var dish: MFDish!
    var quantity: UInt = 0
    var boughtBy: MFUser!
    var status: MFOrderStatus = .pending
    var createdAt: Date!
    var shippingMethod: MFShippingMethod!
    var shippingAddress: MFShippingAddress!
    var deliveryOption: MFDeliveryOption?
    var paymentMethod: MFPaymentMethod!
    var paymentDetails: MFPaymentDetails?
    
    init(from orderDataDictionary:[String:AnyObject]){
        var Dishid = orderDataDictionary["dishId"] as? String ?? ""
        var quantity = orderDataDictionary["quantity"] as? String ?? ""
    }
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
