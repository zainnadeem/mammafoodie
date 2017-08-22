//
//  UberRushDeliveryWorker.swift
//  mammafoodie
//
//  Created by GoodWorkLabs on 15/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit
import Alamofire

class UberRushDeliveryWorker:NSObject {
    
    //FIXME: - change it to prod url
    let uberBaseURL = "https://sandbox-api.uber.com/v1"
    
    var params: [String: Any]!
    
    var pickup: MFUserAddress?
    var dropoff: MFUserAddress?
    var chef: MFUser?
    var purchasingUser: MFUser?
    var order: [MFDish]!
    
    var headers: HTTPHeaders!
    
    static let uberClientID = "89wveeSBo4AfC6doK4YgbtCWYs4kw_ue"
    static let uberClientSecret = "2Hkd-O8-cePVfxQgn2ISdku-ztoGJfMzsdcCC1Ug"
    static let uberUrlScheme = "mammafoodie-uber://oauth"
    
    init(pickup: MFUserAddress, dropoff: MFUserAddress, chef: MFUser, purchasingUser: MFUser, order:[MFDish], accessToken: String) {
        
        super.init()
        
        self.updateParams(pickup: pickup, dropoff: dropoff, chef: chef, purchasingUser: purchasingUser, order: order)
        
        self.headers = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
    }
    
    func updateParams(pickup: MFUserAddress?, dropoff: MFUserAddress?, chef: MFUser?, purchasingUser: MFUser?, order:[MFDish]) {
        
        self.purchasingUser = purchasingUser
        self.order = order
        self.pickup = pickup
        self.dropoff = dropoff
        self.chef = chef
        
        var pickupLocation: [String: Any] = [:]
        if let pickup = pickup {
            pickupLocation = [
                "address"       : pickup.address,
                "address_2"     : pickup.address_2,
                "city"          : pickup.city,
                "country"       : "US",
                "postal_code"   : pickup.postalCode,
                "state"         : pickup.state,
                "latitude"      : pickup.latitude,
                "longitude"     : pickup.longitude
            ]
        }
        
        var pickupContact: [String: Any] = [:]
        if let chef = chef {
            pickupContact = [
                "email"         : chef.email,
                "first_name"    : chef.firstName,
                "last_name"     : chef.lastName,
                "phone"         : [
                    "number" : chef.phone.fullString(),
                    "sms_enabled" : true
                ]
            ]
        }
        
        var dropoffLocation: [String: Any] = [:]
        if let dropoff = dropoff {
            dropoffLocation = [
                "address"       : dropoff.address,
                "address_2"     : dropoff.address_2,
                "city"          : dropoff.city,
                "country"       : "US",
                "postal_code"   : dropoff.postalCode,
                "state"         : dropoff.state,
                "latitude"      : dropoff.postalCode,
                "longitude"     : dropoff.postalCode
            ]
        }
        
        var dropoffContact: [String: Any] = [:]
        if let purchasingUser = purchasingUser {
            dropoffContact = [
                "email"         : purchasingUser.email,
                "first_name"    : purchasingUser.firstName,
                
                "last_name" : purchasingUser.lastName,
                "phone" : [
                    "number" : purchasingUser.phone.fullString(),
                    "sms_enabled" : true
                ]
            ]
        }
        
        
        self.params = [
            "dropoff" : [
                "location" : dropoffLocation,
                "contact" : dropoffContact
            ],
            "pickup" : [
                "location" : pickupLocation,
                "contact" : pickupContact
            ]
        ]
    }
    
    func updatePurchasingUserPhoneNumber(_ phoneNumber: String) {
        var phone: MFUserPhone = MFUserPhone()
        phone.phone = phoneNumber
        phone.countryCode = "+1"
        self.purchasingUser?.phone = phone
        self.updateParams(pickup: self.pickup,
                          dropoff: self.dropoff,
                          chef: self.chef,
                          purchasingUser: self.purchasingUser,
                          order: self.order)
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
    
    func createDelivery(with quoteId: String, completion: @escaping (String?) -> ()) {
        
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
        
        self.params["quote_id"] = quoteId
        
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
    
    func assignVehicleToDelivery(deliveryId: String, completion: @escaping (Bool) -> ()) {
        let urlString = "\(uberBaseURL)/sandbox/deliveries/\(deliveryId)"
        
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
