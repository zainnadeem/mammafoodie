import UIKit

protocol CommentsRouterInput {

}

class CommentsRouter: CommentsRouterInput {

    weak var viewController: CommentsViewController!
    
    // MARK: - Navigation
    
    func passDataToNextScene(segue: UIStoryboardSegue) {
        // NOTE: Teach the router which scenes it can communicate with

    }
}
