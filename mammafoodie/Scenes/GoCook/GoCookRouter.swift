import UIKit

protocol GoCookRouterInput {
    
}

class GoCookRouter: GoCookRouterInput {
    
    weak var viewController: GoCookViewController!
    
    // MARK: - Navigation
    
    func passDataToNextScene(segue: UIStoryboardSegue) {
        // NOTE: Teach the router which scenes it can communicate with

    }
}
