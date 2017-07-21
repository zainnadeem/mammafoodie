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
    
    // Need to update this
    //    class func dictionary(from media: MFDish) -> FirebaseDictionary {
    //        return [
    //            media.id: [
    //                "id" : media.id,
    //                "user" : [
    //                    "id" : media.user.id,
    //                    "name" : media.user.name
    //                ],
    //                "type" : media.type.rawValue,
    //                "cover_small" : media.cover_small?.absoluteString ?? "",
    //                "cover_large" : media.cover_large?.absoluteString ?? "",
    //                "media_url" : media.mediaURL?.absoluteString ?? "",
    //                "dishId" : media.dish.id,
    //                "createdAt" : media.createdAt.timeIntervalSinceReferenceDate,
    //                "endedAt" : media.createdAt.timeIntervalSinceReferenceDate
    //                ] as AnyObject
    //        ]
    //    }
    
    class func dictionary(from comment: MFComment) -> FirebaseDictionary {
        comment.id = FirebaseReference.dishComments.generateAutoID()
        let raw: FirebaseDictionary = [
            comment.id: [
                "id": comment.id,
                "text": comment.text,
                "createTimestamp": comment.createdAt.timeIntervalSinceReferenceDate,
                "user": [
                    "id": comment.user!.id,
                    "name": comment.user!.name
                ]
                ] as AnyObject
        ]
        return raw
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
        return [dish.id : rawDish as AnyObject]
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
        return [
            user.id : [
                "id"                : user.id as AnyObject,
                "name"              : user.name as AnyObject,
                "email"             : user.email as AnyObject,
//                "address"           : user.address as AnyObject,
//                "addressLocation"   : user.addressLocation as AnyObject,
                "picture"           : user.picture as AnyObject,
                "dishesSoldCount"   : user.dishesSoldCount as AnyObject,
                "profileDescription": user.profileDescription as AnyObject,
                "phone"             : user.phone as AnyObject
//                "socialAccountIDs"  : user.socialAccountIds as AnyObject,
//                "userActivity"      : user.userActivity as AnyObject,
//                "cookedDishes"      : user.cookedDishes as AnyObject,
//                "boughtDishes"      : user.boughtDishes as AnyObject,
//                "favouriteDishes"   : user.favoriteDishes as AnyObject,
//                "likedDishes"       : user.likedDishes as AnyObject,
//                "followers"         : user.followers as AnyObject,
//                "following"         : user.following as AnyObject,
//                "blocked"           : user.blocked as AnyObject
                
                ] as AnyObject
        ]
    }
    
    
    class func dictionary(from address:MFUserAddress) -> FirebaseDictionary{
        
        return  [
                
                "id"            :   address.id as AnyObject,
                "address"       :   address.address as AnyObject,
                "address_2"     :   address.address_2 as AnyObject,
                "city"          :   address.city as AnyObject,
                "country"       :   address.country  as AnyObject,
                "state"         :   address.state as AnyObject,
                "postalCode"    :   address.postalCode as AnyObject,
                "latitude"      :   address.latitude as AnyObject,
                "longitude"     :   address.longitude as AnyObject,
                "phone"         :   address.phone   as AnyObject
            ]
        
    }
}
