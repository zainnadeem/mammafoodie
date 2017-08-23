import UIKit

protocol HomeRouterInput {
    
}

class HomeRouter: HomeRouterInput {
    
    weak var viewController: HomeViewController!
    
    // MARK: - Navigation
    
    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
        // NOTE: Teach the router which scenes it can communicate with
        if segue.identifier == "segueShowLiveVideoDetails" {
            (segue.destination as! LiveVideoViewController).liveVideo = sender as! MFDish
        } else if segue.identifier == "segueShowDealDetails" {
            let dish: MFDish = sender as! MFDish
            (segue.destination as! DealDetailViewController).DishId = dish.id
            (segue.destination as! DealDetailViewController).dish = dish
            (segue.destination as! DealDetailViewController).userId = dish.user.id
        } else if segue.identifier == "segueGoCook" {
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
        } else if segue.identifier == "segueShowUserProfileVC" {
            if let nav = segue.destination as? UINavigationController {
                if let profileVC = nav.viewControllers.first as? OtherUsersProfileViewController,
                    let profileData = sender as? (ProfileType, String) {
//                    profileVC.profileType = profileData.0
                    profileVC.userID = profileData.1
                }
            }
        }
    }
}
