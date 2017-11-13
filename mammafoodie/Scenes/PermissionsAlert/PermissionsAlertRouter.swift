import UIKit

protocol PermissionsAlertRouterInput {

}

class PermissionsAlertRouter: PermissionsAlertRouterInput {

    weak var viewController: PermissionsAlertViewController!
    
    // MARK: - Navigation
    
    func passDataToNextScene(segue: UIStoryboardSegue) {
        // NOTE: Teach the router which scenes it can communicate with

    }
}
