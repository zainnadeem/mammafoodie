import UIKit

protocol ChatInteractorInput {
    func chatWorkerInfo()

}

protocol ChatInteractorOutput {
}

class ChatInteractor: ChatInteractorInput {
    
    var output: ChatInteractorOutput!
    var worker: ChatWorker!
    lazy var ChatWorkerInfo = ChatWorker()

    
    // MARK: - Business logic
    
    func chatWorkerInfo()
    {
        
        ChatWorkerInfo.callAPI { message in
            let response = Chat.Response(arrayOfLiveChat: message)
            print(response)
        }
    }
    
//    func responseFromServer(){
//        let response = NSDictionary()
//        let msgID = response["id"]
//        let msgText = response["text"] as String
//        
//        let model = Message(name: <#T##String#>, messageText: msgText, messageId: <#T##Int#>, conversationId: <#T##Int#>, senderId: <#T##Int#>, receiverId: <#T##Int#>, datetime: <#T##Double#>, SenderCopyDeleted: <#T##String#>, ReceiverCopyDeleted: <#T##String#>)
//        
//    }
}
