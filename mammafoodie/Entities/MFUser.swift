//
//  MFUser.swift
//  mammafoodie
//
//  Created by GoodWorkLabs on 15/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import Foundation

struct MFUser {
    
    var id:String
    var name:String
    var email:String
    var phone:String
    var address: MFUserAddress
    var followers:[MFUser]
    var following: [MFUser]
    var cookedDishes:[MFDish]
    var boughtDishes:[MFDish]
    
    
}
