import UIKit

protocol ChatListPresenterInput {
    
}

protocol ChatListPresenterOutput: class {
    
}

class ChatListPresenter: ChatListPresenterInput {
    weak var output: ChatListPresenterOutput!
    
    // MARK: - Presentation logic
    
}
