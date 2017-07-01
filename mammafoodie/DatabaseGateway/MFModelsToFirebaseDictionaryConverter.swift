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
        return [
            dish.id: [
                "id" : dish.id,
                "user" : [
                    "id" : dish.user.id,
                    "name" : dish.user.name
                ],
                "media" : [
                    "id": dish.media.id,
                    "type": dish.media.type.rawValue
                ],
                "mediaType": dish.media.type.rawValue,
                "name" : dish.name,
                "likesCount" : 0,
                "commentsCount" : 0,
                "description" : dish.description ?? "",
                "totalSlots" : dish.totalSlots,
                "pricePerSlot" : dish.pricePerSlot,
                "availableSlots" : dish.totalSlots,
                "type" : dish.type.rawValue,
                "preparationTime" : dish.preparationTime,
                "cuisine" : [
                    "id" : dish.cuisine.id,
                    "name" : dish.cuisine.name
                ]
                ] as AnyObject
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
    
}
