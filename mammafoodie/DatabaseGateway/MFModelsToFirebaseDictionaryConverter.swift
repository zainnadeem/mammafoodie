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
    class func dictionary(from liveStream: MFMedia) -> FirebaseDictionary {
        return [
            liveStream.id: liveStream.id as AnyObject
        ]
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
                "profileDescription": user.profileDescription as AnyObject,
                "socialAccountIDs"  : user.socialAccountIds as AnyObject,
                "userActivity"      : user.userActivity as AnyObject,
                "cookedDishes"      : user.cookedDishes as AnyObject,
                "boughtDishes"      : user.boughtDishes as AnyObject,
                "favouriteDishes"   : user.favoriteDishes as AnyObject,
                "likedDishes"       : user.likedDishes as AnyObject,
                "followers"         : user.followers as AnyObject,
                "following"         : user.following as AnyObject,
                "blocked"           : user.blocked as AnyObject
                
                ] as AnyObject
        ]
    }
    
    
    class func dictionary(from dish:MFDish) -> FirebaseDictionary {
        
        return [
        
            dish.id : [
                "id"            : dish.id as AnyObject,
                "name"          : dish.name as AnyObject,
                "chefID"        : dish.chefID as AnyObject,
                "mediaID"       : dish.mediaID as AnyObject,
                "description"   : dish.description as AnyObject,
                "totalSlots"    : dish.totalSlots as AnyObject,
                "availableSlots": dish.availableSlots as AnyObject,
                "pricePerSlot"  : dish.pricePerSlot as AnyObject,
                "boughtOrders"  : dish.boughtOrders as AnyObject,
                "cuisineID"     : dish.cuisineID as AnyObject
            ]
        ]
    }
    
    
//    class func dictionary(from media: MFMedia) -> FirebaseDictionary{
//       return [
//            media.accessMode = .owner as AnyObject
//        ]
//    }
    
    
    
    
    
    
//    class func dictionary(from liveVideoGateway: MFLiveVideoGatewayAccountDetails) -> FirebaseDictionary {
//        return [
//            liveVideoGateway.host: liveVideoGateway.port as AnyObject
//        ]
//    }
}
