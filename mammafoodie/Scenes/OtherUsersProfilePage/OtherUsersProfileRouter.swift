import UIKit

protocol OtherUsersProfileRouterInput {

}

class OtherUsersProfileRouter: OtherUsersProfileRouterInput {

    weak var viewController: OtherUsersProfileViewController!
    
    // MARK: - Navigation
    
    func passDataToNextScene(segue: UIStoryboardSegue) {
        // NOTE: Teach the router which scenes it can communicate with

    }
}
