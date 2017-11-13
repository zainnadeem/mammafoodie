//
//  MFUserAddress.swift
//  mammafoodie
//
//  Created by GoodWorkLabs on 15/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import Foundation

struct MFUserAddress: CustomStringConvertible {
    
    var id:String!
    var address:String!
    var address_2:String!
    var city:String!
    var country:String!
    var state:String!
    var postalCode:String!
    var latitude:String!
    var longitude:String!
    var phone:String!
    
    var location: String {
        guard let lat = self.latitude else {
            return ""
        }
        
        guard let long = self.longitude else {
            return ""
        }
        
        return "\(lat),\(long)"
    }
    
    init(from dictionary:[String:AnyObject]){
        
        self.id = dictionary["id"] as? String ?? ""
        self.address = dictionary["address"] as? String ?? ""
        self.address_2 = dictionary["address_2"] as? String ?? ""
        self.city = dictionary["city"]  as? String ?? ""
        self.state = dictionary["state"] as? String ?? ""
        self.postalCode = dictionary["postalCode"] as? String ?? ""
        self.latitude = dictionary["latitude"] as? String ?? ""
        self.longitude = dictionary["longitude"] as? String ?? ""
        self.phone = dictionary["phone"] as? String ?? ""
        self.country = "US"
    }
    
    init() {
        
    }
    
    var description: String {
        var components: [String] = []
        if self.address != nil {
            components.append(self.address!)
        }
        if self.address_2 != nil {
            components.append(self.address_2!)
        }
        if self.city != nil {
            components.append(self.city!)
        }
        if self.state != nil {
            components.append(self.state!)
        }
        if self.postalCode != nil {
            components.append(self.postalCode!)
        }
        if self.country != nil {
            components.append(self.country!)
        }
        return components.joined(separator: ", ")
    }
    
}
