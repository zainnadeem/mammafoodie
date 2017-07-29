import UIKit

protocol OtherUsersProfileRouterInput {

}

class OtherUsersProfileRouter: OtherUsersProfileRouterInput {

    weak var viewController: OtherUsersProfileViewController!
    
    // MARK: - Navigation
    
    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
        // NOTE: Teach the router which scenes it can communicate with
        if segue.identifier == "GoCookSegue" {
        let navigationController: MFNavigationController = segue.destination as! MFNavigationController
        let goCookVC: GoCookViewController = navigationController.viewControllers.first as! GoCookViewController
        _ = goCookVC.view
            goCookVC.dishCreated = { (newDish) in
                self.viewController.openDishDetails(newDish)
            }
            if let dishType = sender as? MFDishMediaType {
                if dishType == MFDishMediaType.liveVideo {
                    // live video
                    goCookVC.selectedOption = .liveVideo
                } else if (sender as! MFDishMediaType) == MFDishMediaType.vidup {
                    // vidup
                    goCookVC.selectedOption = .vidup
                }
            }
        
        
        }
    }
}
