import UIKit

protocol LiveVideoRouterInput {

}

class LiveVideoRouter: LiveVideoRouterInput {

    weak var viewController: LiveVideoViewController!
    
    // MARK: - Navigation
    
    func passDataToNextScene(segue: UIStoryboardSegue) {
        // NOTE: Teach the router which scenes it can communicate with

    }
}
