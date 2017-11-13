import UIKit

protocol RequestDishRouterInput {

}

class RequestDishRouter: RequestDishRouterInput {

    weak var viewController: RequestDishViewController!
    
    // MARK: - Navigation
    
    func passDataToNextScene(segue: UIStoryboardSegue) {
        // NOTE: Teach the router which scenes it can communicate with

    }
}
