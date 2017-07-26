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
    
    static let shared: StripeGateway = StripeGateway()
    
    // Test keys
    let stripeTestKeyFromAkshitAccount: String = "pk_test_TsSjdg0sGrs3PxJxoPQpjYM5"
    let stripeTestKeyFromMammaFoodieAccount: String = "pk_test_GR7oEMC78jWcX3qsXVXlMsuC"
    
    private init() {
        STPPaymentConfiguration.shared().publishableKey = self.stripeTestKeyFromMammaFoodieAccount
    }
    
    func addPaymentMethod(number: String, expMonth: UInt, expYear: UInt, cvc: String, completion: @escaping ((String?, Error?)->Void)) {
        let cardParams = STPCardParams()
        cardParams.number = number
        cardParams.expMonth = expMonth
        cardParams.expYear = expYear
        cardParams.cvc = cvc
        STPAPIClient.shared().createToken(withCard: cardParams) { (token, error) in
            if let error = error {
                // Show the error to the user
                print(error)
                completion(nil, error)
            } else if let token = token {
                self.submitTokenToBackend(token, completion: { (cardId, error) in
                    print(error ?? "")
                    completion(cardId, error)
                })
            }
        }
    }
    
    func createCharge(amount: Double, sourceId: String, fromUserId: String, toUserId: String, completion: @escaping ((Error?)->Void)) {
        DatabaseGateway.sharedInstance.createCharge(amount, source: sourceId, fromUserId: fromUserId, toUserId: toUserId) { (error) in
            print("Charged")
            completion(error)
            if error == nil {
                // Transaction success. Add the amount in the digital wallet
//                DatabaseGateway.sharedInstance.updateWalletBalance(with: amount, completion: { (error) in
//                    
//                })
            }
        }
    }
    
    func submitTokenToBackend(_ token: STPToken, completion: @escaping ((String, Error?)->Void)) {
        DatabaseGateway.sharedInstance.addToken(token.tokenId) { (cardId, error) in
            completion(cardId, error)
        }
    }
    
    
    func getPaymentSources(for userId: String, completion: @escaping (([STPCard])->Void)) {
        DatabaseGateway.sharedInstance.getPaymentSources(for: userId) { (rawSources) in
            var sources: [STPCard] = []
            if let rawSources = rawSources {
                for rawSourceId in rawSources.keys {
                    if let rawSource = rawSources[rawSourceId] as? [String:AnyObject] {
                        if let card: STPCard = self.getStripeCard(from: rawSource) {
                            sources.append(card)
                        }
                    }
                }
            }
            completion(sources)
        }
    }
    
    private func getStripeCard(from rawSource: [String:AnyObject]) -> STPCard? {
        guard let objectType = rawSource["object"] as? String else {
            return nil
        }
        
        guard let cardId = rawSource["id"] as? String else {
            return nil
        }
        
        guard let brandString = rawSource["brand"] as? String else {
            return nil
        }
        
        guard let last4 = rawSource["last4"] as? String else {
            return nil
        }
        
        guard let expMonth = rawSource["exp_month"] as? UInt else {
            return nil
        }
        
        guard let expYear = rawSource["exp_year"] as? UInt else {
            return nil
        }
        
        guard let fundingString = rawSource["funding"] as? String else {
            return nil
        }
        
        return STPCard(id: cardId, brand: STPCard.brand(from: brandString), last4: last4, expMonth: expMonth, expYear: expYear, funding: STPCard.funding(from: fundingString))
    }
}
