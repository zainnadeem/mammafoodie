//
//  MFModelsToFirebaseDictionaryConverter.swift
//  Red5ProDemo
//
//  Created by Akshit Zaveri on 14/06/17.
//  Copyright © 2017 Akshit Zaveri. All rights reserved.
//

import Foundation

class MFModelsToFirebaseDictionaryConverter {
    
    typealias FirebaseDictionary = [String:AnyObject]
    
    class func dictionary(from order: MFOrder) -> FirebaseDictionary {
        var raw: FirebaseDictionary = [
            "id": order.id as AnyObject,
            "dish": [
                "id": order.dish.id,
                "name": order.dish.name,
                "createdBy": order.dish.user.name
                ] as AnyObject,
            "quantity": order.quantity as AnyObject,
            "boughtBy" : [
                "id": order.boughtBy.id,
                "name": order.boughtBy.name
                ] as AnyObject,
            "status": order.status.rawValue as AnyObject,
            "createdAt": order.createdAt.timeIntervalSinceReferenceDate as AnyObject,
            "shippingMethod": order.shippingMethod.rawValue as AnyObject,
            "shippingAddress": [
                "address": order.shippingAddress.address,
                "location": order.shippingAddress.location
                ] as AnyObject,
            "paymentMethod": order.paymentMethod.rawValue as AnyObject,
            "paymentDetails": [
                "id": order.paymentDetails.id,
                "totalCharge": order.paymentDetails.totalCharge,
                ] as AnyObject
        ]
        if let delivery = order.deliveryOption {
            raw["deliveryOption"] = delivery.rawValue as AnyObject
        }
        return raw
    }
    
    class func dictionary(from newsFeed: MFNewsFeed) -> FirebaseDictionary {
        let raw = [
            "id" : newsFeed.id,
            "actionUserID": newsFeed.actionUser.id,
            "actionUserName": newsFeed.actionUser.name,
            "participantUserID" : newsFeed.participantUser.id,
            "participantUserName": newsFeed.participantUser.name,
            "redirectID": newsFeed.redirectID,
            "redirectPath": newsFeed.redirectPath.rawValue,
            "activity": newsFeed.activity.rawValue,
            "text": "",
            "mediaURL": newsFeed.mediaURL?.absoluteString ?? "",
            "likes": newsFeed.likes,
            "createdAt": newsFeed.createdAt.timeIntervalSinceReferenceDate
        ]
        var comments = [[String: AnyObject]]()
        for comment in newsFeed.comments {
            comments.append(MFModelsToFirebaseDictionaryConverter.dictionary(from: comment))
        }
        if comments.count > 0 {
            raw["comments"] = comments
        }
        
        return [newsFeed.id: raw as AnyObject]
    }
    
    class func dictionary(from comment: MFComment) -> FirebaseDictionary {
        let raw = [
            "id": comment.id,
            "text": comment.text,
            "createdAt": comment.createdAt.timeIntervalSinceReferenceDate,
            "refrenceID": comment.refrenceID,
            "user": [
                "id": comment.user!.id,
                "name": comment.user!.name
            ]
        ]
        
        return [comment.id: raw as AnyObject]
    }
    
    class func dictionary(from dish: MFDish) -> FirebaseDictionary {
        let createDate: Date = dish.createTimestamp ?? Date()
        var rawDish: [String:Any] = [
            "id" : dish.id,
            "createTimestamp" : createDate.timeIntervalSinceReferenceDate,
            "user" : [
                "id" : dish.user.id,
                "name" : dish.user.name
            ],
            "mediaType": dish.mediaType.rawValue,
            "name" : dish.name,
            "likesCount" : dish.likesCount,
            "commentsCount" : dish.commentsCount,
            "description" : dish.description ?? "",
            "mediaURL" : dish.mediaURL?.absoluteString ?? "",
            "totalSlots" : dish.totalSlots,
            "pricePerSlot" : dish.pricePerSlot,
            "availableSlots" : dish.totalSlots,
            "dishType" : dish.dishType.rawValue,
            "preparationTime" : dish.preparationTime,
            "cuisine" : [
                "id" : dish.cuisine.id,
                "name" : dish.cuisine.name
            ]
        ]
        
        if dish.endTimestamp != nil {
            rawDish["endTimestamp"] = dish.endTimestamp!.timeIntervalSinceReferenceDate
        }
        if let location = dish.location {
            rawDish["location"] = [
                "latitude" : location.latitude,
                "longitude" : location.longitude,
                "address" : dish.address
                ] as AnyObject
        }
        return [dish.id: rawDish as AnyObject]
    }
    
    class func dictionary(from message: MFMessage) -> FirebaseDictionary {
        return  [
            "id": message.id as AnyObject,
            "messageText": message.messageText as AnyObject,
            //                "conversationId": message.conversationId as AnyObject,
            "senderId": message.senderId as AnyObject,
            "dateTime": message.dateTime as AnyObject,
            "senderDisplayName": message.senderDisplayName as AnyObject
            //                "receiverId": message.receiverId as AnyObject
        ]
    }
    
    class func dictionary(from user: MFUser) -> FirebaseDictionary {
        //        var userInfo: [String:AnyObject] = [
        //            :
        //            //                "socialAccountIDs"  : user.socialAccountIds as AnyObject,
        //            //                "userActivity"      : user.userActivity as AnyObject,
        //            //                "cookedDishes"      : user.cookedDishes as AnyObject,
        //            //                "boughtDishes"      : user.boughtDishes as AnyObject,
        //            //                "favouriteDishes"   : user.favoriteDishes as AnyObject,
        //            //                "likedDishes"       : user.likedDishes as AnyObject,
        //            //                "followers"         : user.followers as AnyObject,
        //            //                "following"         : user.following as AnyObject,
        //            //                "blocked"           : user.blocked as AnyObject
        //
        //        ]
        var userInfo =  [String:AnyObject]()
        
        if let id = user.id {
            userInfo["id"] = id as AnyObject
        }
        
        if let name = user.name {
            userInfo["name"] = name as AnyObject
        }
        
        if let email = user.email {
            userInfo["email"] = email as AnyObject
        }
        
        if let address = user.address {
            userInfo["address"] = address as AnyObject
        }
        
        if let addressLocation = user.addressLocation {
            userInfo["addressLocation"] = addressLocation as AnyObject
        }
        
        if let picture = user.picture {
            userInfo["picture"] = picture as AnyObject
        }
        
        userInfo["dishesSoldCount"] = user.dishesSoldCount as AnyObject
        
        if let profileDescription = user.profileDescription {
            userInfo["profileDescription"] = profileDescription as AnyObject
        }
        
        userInfo["phone"] = user.phone as AnyObject
        return [
            user.id : userInfo as AnyObject
        ]
    }
    
    class func dictionary(from address:MFUserAddress) -> FirebaseDictionary{
        
        return  [ "id"            :   address.id as AnyObject,
                  "address"       :   address.address as AnyObject,
                  "address_2"     :   address.address_2 as AnyObject,
                  "city"          :   address.city as AnyObject,
                  "country"       :   address.country  as AnyObject,
                  "state"         :   address.state as AnyObject,
                  "postalCode"    :   address.postalCode as AnyObject,
                  "latitude"      :   address.latitude as AnyObject,
                  "longitude"     :   address.longitude as AnyObject,
                  "phone"         :   address.phone   as AnyObject ]
        
    }
}
