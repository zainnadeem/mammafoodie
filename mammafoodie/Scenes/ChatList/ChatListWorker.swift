import UIKit

class ChatListWorker {
    // MARK: - Business Logic
    
    var observer : DatabaseConnectionObserver?
    
    func getConversations(forUser userID:String, _ completion:@escaping (MFConversation?)->()){
        
       observer = DatabaseGateway.sharedInstance.getConversations(forUser: userID, { (conv) in
            completion(conv)
        })
        
    }
    
    func stopObserving(){
        observer?.stop()
    }
    
    func createConversation(createdAt: String, user1: String, user2: String, user1Name:String, user2Name:String, _ completion:@escaping (_ status:Bool)->()){
        
        DatabaseGateway.sharedInstance.createConversation(createdAt: createdAt, user1: user1 , user2: user2, user1Name: user1Name, user2Name: user2Name) { (status) in
                completion(status)
        }

    }
   

}
