import UIKit

protocol ChatInteractorInput {
    func chatWorkerInfo(username:String, meassagetext: String)

}

protocol ChatInteractorOutput {
    
}

class ChatInteractor: ChatInteractorInput {
    
    var output: ChatInteractorOutput!
    var worker: ChatWorker!
    lazy var ChatWorkerInfo = ChatWorker()

    
    // MARK: - Business logic
    
    func chatWorkerInfo(username:String, meassagetext: String)
    {
        ChatWorkerInfo.callAPI { (_: [Message]) in
            print(username)
            print(meassagetext)
        }
    }
}
