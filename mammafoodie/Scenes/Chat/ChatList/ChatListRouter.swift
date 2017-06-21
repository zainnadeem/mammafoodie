import UIKit

protocol ChatListRouterInput {

}

class ChatListRouter: ChatListRouterInput {

    weak var viewController: ChatListViewController!
    
    // MARK: - Navigation
    
    func passDataToNextScene(segue: UIStoryboardSegue) {
        // NOTE: Teach the router which scenes it can communicate with

    }
}
