//
//  ChatWorker.swift
//  mammafoodie
//
//  Created by GoodWorkLabs on 21/07/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import Foundation

class ChatWorker{
    
    var observer:DatabaseConnectionObserver?
    
    func getMessages(forConversation conversationID:String, _ completion : @escaping (MFMessage?)->()) {
        
        observer =   DatabaseGateway.sharedInstance.getMessages(forConversation: conversationID) { (message) in
            completion(message)
        }
    }
    
    func stopObserving(){
        observer?.stop()
    }
    
    
    func createMessage(with message: MFMessage, conversationID:String, _ completion:@escaping (_ status:Bool)->()){
    
        DatabaseGateway.sharedInstance.createMessage(with: message, conversationID: conversationID) { (status) in
            completion(status)
        }
    }
        
}
