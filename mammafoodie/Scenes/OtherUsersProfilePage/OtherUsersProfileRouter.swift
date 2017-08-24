import UIKit

protocol OtherUsersProfileRouterInput {

}

class OtherUsersProfileRouter: OtherUsersProfileRouterInput {

    weak var viewController: OtherUsersProfileViewController!
    
    // MARK: - Navigation
    
    func passDataToNextScene(segue: UIStoryboardSegue) {
        // NOTE: Teach the router which scenes it can communicate with
        if segue.identifier == "segueGoCook" {
            let navigationController: MFNavigationController = segue.destination as! MFNavigationController
            let goCookVC: GoCookViewController = navigationController.viewControllers.first as! GoCookViewController
            _ = goCookVC.view
            goCookVC.dishCreated = { (newDish) in
                self.viewController.openDishDetails(newDish)
            }
        }
    }
}
