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
    
    class func dictionary(from liveStream: MFLiveStream) -> FirebaseDictionary {
        return [
            liveStream.id: liveStream.name as AnyObject
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
