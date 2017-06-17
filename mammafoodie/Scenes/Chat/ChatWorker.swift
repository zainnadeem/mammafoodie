
import Foundation
import Firebase
import JSQMessagesViewController


class ChatWorker {
    let model = MFConversation()
    let modelMsg = MFMessage(with: "", messagetext: "", senderId: "")
    var messages = [JSQMessage]()
    

    func callAPI(completion: @escaping ([MFMessage]) -> Void) {
        
//        let video = Message(name: "1")
        DatabaseGateway.sharedInstance.createConversation(with:model) {newModel in
            print(self.model)
        }
        DatabaseGateway.sharedInstance.createMessage(with: modelMsg) {_ in
            print(self.modelMsg)
            completion([self.modelMsg])

        }
    }
        
}
