//
//  EditProfileworker.swift
//  mammafoodie
//
//  Created by GoodWorkLabs on 18/07/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import Foundation


class EditProfileworker {
    
    var addressResponseCount = 0
    
    func getUserDataWith(userID:String, completion: @escaping (MFUser?)->Void){
        
        _ = DatabaseGateway.sharedInstance.getUserWith(userID: userID) { (user) in
            completion(user)
        }
    }
    
    func getUserAddress(userID:String, completion: @escaping ([MFUserAddress]?)->Void){
        
        addressResponseCount = 0
        
        DatabaseGateway.sharedInstance.getAddressForUser(userID: userID) { (addressData) in
            
            guard addressData != nil else {
                completion([])
                return
            }
            
            var addresses = [MFUserAddress]()
            
            for addressID in addressData!.keys {
                
                DatabaseGateway.sharedInstance.getAddress(addressID: addressID, { (address) in
                    
                    self.addressResponseCount += 1
                    
                    if address != nil {
                        addresses.append(address!)
                    }
                    
                    if self.addressResponseCount == addressData!.keys.count {
                        self.addressResponseCount = 0
                        completion(addresses)
                    }
                })
                
            }
            
        }
    
    }
    
    func createAddressForUser(userID:String, address:MFUserAddress, _ completion:@escaping (_ status:Bool)->()){
        
        DatabaseGateway.sharedInstance.createAddress(userID: userID, address: address) { (id) in
            if id != nil {
                completion(true)
            } else {
                completion(false)
            }
        }
        
    }
    
    
    func updateAddress(addressID:String, address:MFUserAddress,_ completion:@escaping (_ status:Bool)->()){
        DatabaseGateway.sharedInstance.updateAddress(addressID: addressID, address: address) { (status) in
            completion(status)
        }
    }
    
    func updateUser(user:MFUser, _ completion:@escaping (_ status:Bool)->()){
        DatabaseGateway.sharedInstance.updateUserEntity(with: user) { (error) in
            if error != nil {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    
    func uploadProfileImage(userID:String, image:UIImage, _ completion:@escaping (_ status:Bool)->()) {
             DatabaseGateway.sharedInstance.uploadProfileImage(userID: userID, image: image) { (url, error) in
                if error != nil {
                    completion(false)
                } else if url != nil {
                    completion(true)
                } else {
                    completion(false)
                }
        }
    }
    
}
