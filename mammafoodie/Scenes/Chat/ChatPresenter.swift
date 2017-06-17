import UIKit

protocol ChatPresenterInput {
    func chatWorkerInfo(meassagetext: String)

}

protocol ChatPresenterOutput: class {

}

class ChatPresenter: ChatPresenterInput {
    weak var output: ChatPresenterOutput!
    
    // MARK: - Presentation logic
    
    func chatWorkerInfo(meassagetext: String)
    {
        
    }
}
