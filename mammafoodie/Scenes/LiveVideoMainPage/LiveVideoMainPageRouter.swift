import UIKit

protocol LiveVideoMainPageRouterInput {

}

class LiveVideoMainPageRouter: LiveVideoMainPageRouterInput {

    weak var viewController: LiveVideoMainPageViewController!
    
    // MARK: - Navigation
    
    func passDataToNextScene(segue: UIStoryboardSegue) {
        // NOTE: Teach the router which scenes it can communicate with

    }
}
