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
    
//    class func dictionary(from liveVideoGateway: MFLiveVideoGatewayAccountDetails) -> FirebaseDictionary {
//        return [
//            liveVideoGateway.host: liveVideoGateway.port as AnyObject
//        ]
//    }
}
