import UIKit

protocol ChatListInteractorInput {
    
}

protocol ChatListInteractorOutput {
    
}

class ChatListInteractor: ChatListInteractorInput {
    
    var output: ChatListInteractorOutput!
    var worker: ChatListWorker!
    
    // MARK: - Business logic
    
}
