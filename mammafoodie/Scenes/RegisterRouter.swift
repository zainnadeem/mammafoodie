import UIKit

protocol RegisterRouterInput {

}

class RegisterRouter: RegisterRouterInput {

    weak var viewController: RegisterViewController!
    
    // MARK: - Navigation
    
    func passDataToNextScene(segue: UIStoryboardSegue) {
        // NOTE: Teach the router which scenes it can communicate with

    }
}
