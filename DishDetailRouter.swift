import UIKit

protocol DishDetailRouterInput {

}

class DishDetailRouter: DishDetailRouterInput {

    weak var viewController: DishDetailViewController!
    
    // MARK: - Navigation
    
    func passDataToNextScene(segue: UIStoryboardSegue) {
        // NOTE: Teach the router which scenes it can communicate with

    }
}
