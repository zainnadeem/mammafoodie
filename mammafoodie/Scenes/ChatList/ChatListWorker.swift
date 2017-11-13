import UIKit

class ChatListWorker {
    // MARK: - Business Logic
    
    var observer : DatabaseConnectionObserver?
    
    func getConversations(forUser userID: String, _ completion: @escaping (MFConversation?) -> ()) {
       self.observer = DatabaseGateway.sharedInstance.getConversations(forUser: userID, { (conv) in
            completion(conv)
        })
        
    }
    
    func stopObserving(){
        self.observer?.stop()
    }
    
    func createConversation(user1: MFUser, user2: MFUser,_ completion: @escaping (Bool) -> ()) {
//        DatabaseGateway.sharedInstance.createConversation(createdAt: "\(Date().timeIntervalSinceReferenceDate)", user1: user1.id , user2: user2.id, user1Name: user1.name, user2Name: user2.name) { (status) in
//                completion(status)
//        }

    }
   
}
