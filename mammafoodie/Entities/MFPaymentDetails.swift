import Foundation

class MFPaymentDetails {
    var id: String!
    var order: MFOrder!
    var deliveryCharge: Double = 0
    var tax: Double = 0
    var mammafoodieCharge: Double = 0
    var totalCharge: Double = 0
}

extension MFPaymentDetails: Hashable {
    var hashValue: Int {
        return self.id.hashValue
    }
}

extension MFPaymentDetails: Equatable {
    static func ==(lhs: MFPaymentDetails, rhs: MFPaymentDetails) -> Bool {
        return lhs.id == rhs.id
    }
}
