import UIKit

protocol ForgotPasswordRouterInput {

}

class ForgotPasswordRouter: ForgotPasswordRouterInput {

    weak var viewController: ForgotPasswordViewController!
    
    // MARK: - Navigation
    
    func passDataToNextScene(segue: UIStoryboardSegue) {
        // NOTE: Teach the router which scenes it can communicate with

    }
}
