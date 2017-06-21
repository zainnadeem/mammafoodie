import UIKit

protocol HomeRouterInput {

}

class HomeRouter: HomeRouterInput {

    weak var viewController: HomeViewController!
    
    // MARK: - Navigation
    
    func passDataToNextScene(segue: UIStoryboardSegue) {
        // NOTE: Teach the router which scenes it can communicate with

    }
}
