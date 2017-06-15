import UIKit

protocol NearbyChefsRouterInput {

}

class NearbyChefsRouter: NearbyChefsRouterInput {

    weak var viewController: NearbyChefsViewController!
    
    // MARK: - Navigation
    
    func passDataToNextScene(segue: UIStoryboardSegue) {
        // NOTE: Teach the router which scenes it can communicate with

    }
}
