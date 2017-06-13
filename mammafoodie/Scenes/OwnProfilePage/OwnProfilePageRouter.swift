import UIKit

protocol OwnProfilePageRouterInput {

}

class OwnProfilePageRouter: OwnProfilePageRouterInput {

    weak var viewController: OwnProfilePageViewController!
    
    // MARK: - Navigation
    
    func passDataToNextScene(segue: UIStoryboardSegue) {
        // NOTE: Teach the router which scenes it can communicate with

    }
}
