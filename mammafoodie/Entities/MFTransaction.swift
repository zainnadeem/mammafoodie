//
//  MFTransaction.swift
//  mammafoodie
//
//  Created by Akshit Zaveri on 07/09/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import Foundation

enum PaymentPurpose: String {
    case tip = "tip"
    case purchase = "purchase"
    case unknown = "unknown"
}

class MFTransaction {
    
    var amount: Double = 0
    var currency: String = ""
    var purpose: PaymentPurpose = .unknown
    
    var fromUserId: String = ""
    var fromUsername: String = ""
    
    var toUserId: String = ""
    var toUsername: String = ""
    
    var dishId: String?
    var dishName: String?
    
    init() {
        
    }
    
    func getReadableText() -> String {
        var text: String = ""
        let amountString: String = "$\(amount/100)"
        if self.purpose == .tip {
            text = "\(fromUsername) tipped you \(amountString)"
            if let dishName = dishName {
                text += " for \(dishName)"
            }
        } else {
            text = "purchased \(dishName!) for \(amountString)"
        }
        return text
    }
}
