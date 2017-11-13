import UIKit

protocol NearbyChefsRouterInput {

}

class NearbyChefsRouter: NearbyChefsRouterInput {

    weak var viewController: NearbyChefsViewController!
    
    // MARK: - Navigation
    
    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
        // NOTE: Teach the router which scenes it can communicate with
        if segue.identifier == "segueShowLiveVideoDetails" {
            (segue.destination as! LiveVideoViewController).liveVideo = sender as! MFDish
        } else if segue.identifier == "segueShowDealDetails" {
            if let destination = segue.destination as? DealDetailViewController {
                if let dish: MFDish = sender as? MFDish {
                    destination.DishId = dish.id
                    destination.dish = dish
                    destination.userId = dish.user.id
                } else if let action = sender as? (MFDish, Bool) {
                    let dish = action.0
                    let orderNow = action.1
                    destination.DishId = dish.id
                    destination.dish = dish
                    destination.userId = dish.user.id
                    destination.shouldShowSlotSelection = orderNow
                }
            }
        }
    }
}
