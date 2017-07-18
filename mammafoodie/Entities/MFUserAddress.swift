//
//  MFUserAddress.swift
//  mammafoodie
//
//  Created by GoodWorkLabs on 15/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import Foundation

struct MFUserAddress:CustomStringConvertible{
    
    var address:String
    var address_2:String
    var city:String
    var country:String
    var state:String
    var postalCode:String
    var latitude:String
    var longitude:String
    var phone:String
    
    init(from dictionary:[String:AnyObject]){
        
        self.address = dictionary["address"] as? String ?? ""
        self.address_2 = dictionary["address_2"] as? String ?? ""
        self.city = dictionary["city"]  as? String ?? ""
        self.country = dictionary["country"] as? String ?? "US"
        self.state = dictionary["state"] as? String ?? ""
        self.postalCode = dictionary["postalCode"] as? String ?? ""
        self.latitude = dictionary["latitude"] as? String ?? ""
        self.longitude = dictionary["longitude"] as? String ?? ""
        self.phone = dictionary["phone"] as? String ?? ""
    }
    
    
    var description: String {
        return "\(self.address),\(self.address_2),\(self.city),\(self.state),\(self.country)"
    }
    
}
