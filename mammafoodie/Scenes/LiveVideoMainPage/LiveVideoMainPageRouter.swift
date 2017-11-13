import UIKit

protocol LiveVideoMainPageRouterInput {

}

class LiveVideoMainPageRouter: LiveVideoMainPageRouterInput {

    weak var viewController: LiveVideoMainPageViewController!
    
    // MARK: - Navigation
    
    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
        // NOTE: Teach the router which scenes it can communicate with
        if segue.identifier == "segueShowLiveVideoDetails" {
            (segue.destination as! LiveVideoViewController).liveVideo = sender as! MFDish
        }
    }
}
