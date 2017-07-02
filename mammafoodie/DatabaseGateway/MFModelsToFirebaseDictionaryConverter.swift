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
    class func dictionary(from media: MFMedia) -> FirebaseDictionary {
        return [
            media.id: [
                "id" : media.id,
                "user" : [
                    "id" : media.user.id,
                    "name" : media.user.name
                ],
                "type" : media.type.rawValue,
                "cover_small" : media.cover_small?.absoluteString ?? "",
                "cover_large" : media.cover_large?.absoluteString ?? "",
                "media_url" : media.mediaURL?.absoluteString ?? "",
                "dishId" : media.dish.id,
                "createdAt" : media.createdAt.timeIntervalSinceReferenceDate,
                "endedAt" : media.createdAt.timeIntervalSinceReferenceDate
                ] as AnyObject
        ]
    }
    
    class func dictionary(from dish: MFDish) -> FirebaseDictionary {
        var mediaURL : String! = ""
        if dish.mediaURL != nil {
            mediaURL = dish.mediaURL.absoluteString
        }
        let dict =
            [dish.id : [
                "id" : dish.id,
                "createTimestamp" : dish.createdAt.timeIntervalSinceReferenceDate,
                "endTimestamp" : dish.endedAt.timeIntervalSinceReferenceDate,
                "user" : [
                    "id" : dish.user.id,
                    "name" : dish.user.name
                    ],
                "mediaType": dish.mediaType.rawValue,
                "name" : dish.name,
                "likesCount" : dish.likesCount,
                "commentsCount" : dish.commentsCount,
                "description" : dish.description ?? "",
                "mediaURL" : mediaURL!,
                "totalSlots" : dish.totalSlots,
                "pricePerSlot" : dish.pricePerSlot,
                "availableSlots" : dish.totalSlots,
                "dishType" : dish.dishType.rawValue,
                "preparationTime" : dish.preparationTime,
                "cuisine" : [
                    "id" : dish.cuisine.id,
                    "name" : dish.cuisine.name
                    ]
                ] as AnyObject]
        return dict
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
    
}
