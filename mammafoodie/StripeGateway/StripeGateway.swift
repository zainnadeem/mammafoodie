//
//  StripeGateway.swift
//  mammafoodie
//
//  Created by Akshit Zaveri on 17/07/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import Foundation
import Stripe

class StripeGateway {
    
    static let shared = StripeGateway()
    
    init() {
        STPPaymentConfiguration.shared().publishableKey = "pk_test_TsSjdg0sGrs3PxJxoPQpjYM5"
    }
    
    func addPaymentMethod() {
        let cardParams = STPCardParams()
        cardParams.number = "4242424242424242"
        cardParams.expMonth = 10
        cardParams.expYear = 2018
        cardParams.cvc = "123"
        STPAPIClient.shared().createToken(withCard: cardParams) { (token, error) in
            if let error = error {
                // Show the error to the user
                print(error)
            } else if let token = token {
                self.submitTokenToBackend(token, completion: { (error) in
                    print(error ?? "")
                })
            }
        }
    }
    
    func createCharge() {
        DatabaseGateway.sharedInstance.createCharge(1000, source: "") { 
            print("Charged")
        }
    }
    
    func submitTokenToBackend(_ token: STPToken, completion: @escaping ((Error?)->Void)) {
        DatabaseGateway.sharedInstance.addToken(token.tokenId) { 
            completion(nil)
        }
    }
}
