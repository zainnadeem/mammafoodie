import UIKit

protocol VidupDetailPageRouterInput {
    
}

class VidupDetailPageRouter: VidupDetailPageRouterInput {
    
    weak var viewController: VidupDetailPageViewController!
    
    // MARK: - Navigation
    
    func passDataToNextScene(segue: UIStoryboardSegue, sender : Any?) {
        // NOTE: Teach the router which scenes it can communicate with
        if segue.identifier == "segueShowUserProfile" {
            if let destination: UINavigationController = segue.destination as? UINavigationController {
                if let profileVC: OtherUsersProfileViewController = destination.viewControllers.first as? OtherUsersProfileViewController {
                    profileVC.userID = sender as? String
                }
            }
        }
    }
}
