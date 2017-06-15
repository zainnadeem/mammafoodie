import UIKit

protocol ChatPresenterInput {
    
}

protocol ChatPresenterOutput: class {
    
}

class ChatPresenter: ChatPresenterInput {
    weak var output: ChatPresenterOutput!
    
    // MARK: - Presentation logic
    
}
