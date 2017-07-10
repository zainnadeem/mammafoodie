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
        } else if segue.identifier == "segueGoCook" {
            let navigationController: MFNavigationController = segue.destination as! MFNavigationController
            let goCookVC: GoCookViewController = navigationController.viewControllers.first as! GoCookViewController
            _ = goCookVC.view
            goCookVC.dishCreated = { (newDish) in
                self.viewController.openDishDetails(newDish)
            }
            if (sender as! MFDishMediaType) == MFDishMediaType.liveVideo {
                // live video
                goCookVC.selectedOption = .liveVideo
            } else if (sender as! MFDishMediaType) == MFDishMediaType.vidup {
                // vidup
                goCookVC.selectedOption = .vidup
            }
        }
    }
}
