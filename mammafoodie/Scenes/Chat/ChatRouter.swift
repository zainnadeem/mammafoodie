import UIKit

protocol ChatRouterInput {

}

class ChatRouter: ChatRouterInput {

    weak var viewController: ChatViewController!
    
    // MARK: - Navigation
    
    func passDataToNextScene(segue: UIStoryboardSegue) {
        // NOTE: Teach the router which scenes it can communicate with

    }
}
