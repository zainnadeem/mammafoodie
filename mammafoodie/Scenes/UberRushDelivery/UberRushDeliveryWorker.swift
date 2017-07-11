//
//  UberRushDeliveryWorker.swift
//  mammafoodie
//
//  Created by GoodWorkLabs on 15/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit
import Alamofire

class UberRushDeliveryWorker:NSObject{
    
    
    let uberBaseURL = "https://sandbox-api.uber.com/v1"
    
    var uberAccessToken = ""

   
    var params: [String: Any]!
    var purchasingUser: MFUser!
    
    var headers: HTTPHeaders!
    
    static let uberClientID = "89wveeSBo4AfC6doK4YgbtCWYs4kw_ue"
    static let uberClientSecret = "2Hkd-O8-cePVfxQgn2ISdku-ztoGJfMzsdcCC1Ug"
    static let uberUrlScheme = "mammafoodie-uber://oauth"
    
    var order: [MFDish]!
    
 
    
    init(pickup: MFUserAddress, dropoff: MFUserAddress, chef: MFUser, purchasingUser: MFUser, order:[MFDish]) {
        
        self.purchasingUser = purchasingUser
        self.order = order
        
        let pickupLocation = [
            "address"       : pickup.address,
            "address_2"     : pickup.address_2,
            "city"          : pickup.city,
            "country"       : "US",
            "postal_code"   : pickup.postalCode,
            "state"         : pickup.state,
            "latitude"      : pickup.latitude,
            "longitude"     : pickup.longitude
        ]
        let pickupContact: [String: Any] = [
            "email"         : chef.email,
            "first_name"    : chef.firstName,
            "last_name"     : chef.lastName,
            "phone"         : [ "number" : chef.phone, "sms_enabled" : false]
        ]
        
        let dropoffLocation = [
            "address"       : dropoff.address,
            "address_2"     : dropoff.address_2,
            "city"          : dropoff.city,
            "country"       : "US",
            "postal_code"   : dropoff.postalCode,
            "state"         : dropoff.state,
            "latitude"      : pickup.latitude,
            "longitude"     : pickup.longitude
        ]
        let dropoffContact: [String: Any] = [
            "email"         : purchasingUser.email,
            "first_name"    : purchasingUser.firstName,
            "last_name"     : purchasingUser.lastName,
            "phone"         : [ "number" : purchasingUser.phone, "sms_enabled" : false]
        ]
        
        self.params = ["dropoff" : ["location" : dropoffLocation, "contact" : dropoffContact], "pickup" : ["location" : pickupLocation, "contact" : pickupContact]]
        
        headers = [
            "Authorization": "Bearer \(uberAccessToken)",
            "Content-Type": "application/json"
        ]
        
    }
    
    
    
    
    
    func getDeliveryQuote(completion: @escaping ([String : Any]?) -> ()) {
        
        let urlString = "\(uberBaseURL)/deliveries/quote"
        
        Alamofire.request(urlString, method: .post, parameters: self.params, encoding: JSONEncoding.default, headers: self.headers).responseJSON { (response) in
            print("Status code: \(String(describing: response.response?.statusCode))")
            if response.response?.statusCode != 201 {
                print(" There was an error")
                completion(nil)
            }
            if let json = response.result.value as? [String : Any], let quotes = json["quotes"] as? [[String : Any]] {
                print("\n\n\n\n\n\n")
                //                print(json)
                if let firstQuote = quotes.first {
                    //                    completion(firstQuote["quote_id"] as? String)
                    completion(firstQuote)
                }
                
            }
        }
    }
    
    func createDelivery(completion: @escaping (String?) -> ()) {
        
        let urlString = "\(uberBaseURL)/deliveries"
        
        var items = [[String : Any]]()
        for dish in self.order {
            let item: [String : Any] = [
                "currency_code" : "USD",
                "price"         : dish.pricePerSlot,
                "quantity"      : 1,
                "title"         : dish.name
            ]
            items.append(item)
        }
        self.params["items"] = items
        
        //Request a quote
        self.getDeliveryQuote { (quoteID) in
            guard let quoteID = quoteID else { completion(nil); return }
            self.params["quote_id"] = quoteID["quote_id"]
            
            //Request a delivery with the quoteID
            Alamofire.request(urlString, method: .post, parameters: self.params, encoding: JSONEncoding.default, headers: self.headers).responseJSON { (response) in
                
                if response.response?.statusCode != 200 && response.response?.statusCode != 201 {
                    print("There was an error")
                    completion(nil)
                }
                if let json = response.result.value as? [String : Any] {
                    completion(json["delivery_id"] as? String)
                }
            }
        }
    }
    
    func getDeliveryDetails(deliveryID: String, completion: @escaping ([String : Any]?) -> ()) {
        
        let urlString = "\(uberBaseURL)/deliveries/\(deliveryID)"
        
        Alamofire.request(urlString, headers: self.headers).responseJSON { (response) in
            if response.response?.statusCode != 200 {
                print("there was an error in getDeliveryDetails")
                completion(nil)
            }
            if let json = response.result.value as? [String : Any] {
                completion(json)
            }
        }
    }
    
    func assignVehicleToDelivery(deliveryID: String, completion: @escaping (Bool) -> ()) {
        let urlString = "\(uberBaseURL)/sandbox/deliveries/\(deliveryID)"
        
        Alamofire.request(urlString, method: .put, headers: self.headers).responseJSON { (response) in
            if response.response?.statusCode != 204 {
                print("There was an error in assignVehicleToDelivery")
                completion(false)
            }
            if (response.result.value as? [String : Any]) != nil {
                completion(true)
            }
        }
    }
    
    //Gets the auth code if user accepts
    class func getAuthorizationcode(completion:@escaping (_ accessToken:String?) -> ()){
        
        (UIApplication.shared.delegate as! AppDelegate).uberAccessTokenHandler = completion
        
        let urlString = "https://login.uber.com/oauth/v2/authorize?client_id=\(uberClientID)&response_type=code&redirect_uri=\(uberUrlScheme)"
        
        if let url = URL(string: urlString){
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            //If user accepts or denies, the app will get a callback in appdelegate using the url scheme provided
        }
    }
    
    class func getAccessToken(authorizationCode: String, completion: @escaping (_ json:[String : Any]?) -> ()) {
        let urlString = "https://login.uber.com/oauth/v2/token"
        let parameters = ["client_secret"   : uberClientSecret,
                          "client_id"       : uberClientID,
                          "grant_type"      : "authorization_code",
                          "redirect_uri"    : uberUrlScheme,
                          "code"            : authorizationCode
        ]
        Alamofire.request(urlString, method: .post, parameters: parameters).responseJSON { (response) in
            if let json = response.result.value as? [String : Any] {
                
                
                
                completion(json)
            }
        }
    }
    
    class func refreshAccessToken(refreshToken: String, completion: @escaping ([String : Any]?) -> ()) {
        let urlString = "https://login.uber.com/oauth/v2/token"
        let parameters = ["client_secret"   : uberClientSecret,
                          "client_id"       : uberClientID,
                          "grant_type"      : "refresh_token",
                          "refresh_token"   : refreshToken
        ]
        Alamofire.request(urlString, method: .post, parameters: parameters).responseJSON { (response) in
            if let json = response.result.value as? [String : Any] {
                completion(json)
            }
            
        }
        
        
        
        
        
    }
    
}
