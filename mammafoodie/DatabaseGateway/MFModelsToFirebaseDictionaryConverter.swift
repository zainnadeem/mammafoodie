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
        
        var rawDish: [String:Any] = [
            "id" : dish.id,
            "createTimestamp" : dish.createTimestamp.timeIntervalSinceReferenceDate,
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
        
        if dish.mediaType != MFDishMediaType.liveVideo {
            rawDish["endTimestamp"] = dish.endTimestamp?.timeIntervalSinceReferenceDate
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
    
    class func dictionary(from conversation: MFConversation1) -> FirebaseDictionary {
        var dishRequestId: String = ""
        
        if conversation.dishRequestId != nil  {
            dishRequestId = conversation.dishRequestId!
        }
        return [
            conversation.id! : [
                "dishRequestId" : dishRequestId as AnyObject,
                "createdAt": conversation.createdAt as AnyObject
                ] as AnyObject
        ]
    }
    
    class func dictionary(from message: MFMessage1) -> FirebaseDictionary {
        return [
            message.messageid : [
                "messageText": message.messageText as AnyObject,
                "conversationId": message.conversationId as AnyObject,
                "senderId": message.senderId as AnyObject,
                "receiverId": message.receiverId as AnyObject
                ] as AnyObject
        ]
    }
    
    class func dictionary(from user: MFUser) -> FirebaseDictionary {
        return [
            user.id : [
                "id"                : user.id as AnyObject,
                "name"              : user.name as AnyObject,
                "email"             : user.email as AnyObject,
                "address"           : user.address as AnyObject,
                "addressLocation"   : user.addressLocation as AnyObject,
                "picture"           : user.picture as AnyObject,
                "dishesSoldCount"   : user.dishesSoldCount as AnyObject,
                "profileDescription": user.profileDescription as AnyObject
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
}
