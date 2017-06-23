import UIKit

protocol HomeRouterInput {
    
}

class HomeRouter: HomeRouterInput {
    
    weak var viewController: HomeViewController!
    
    // MARK: - Navigation
    
    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
        // NOTE: Teach the router which scenes it can communicate with
        if segue.identifier == "showLiveVideoDetails" {
            (segue.destination as! LiveVideoViewController).liveVideo = sender as! MFMedia
        } else if segue.identifier == "showLiveVideoList" {
            
        } else if segue.identifier == "showVidupDetails" {
            
        } else if segue.identifier == "showVidupsList" {
            
        } else if segue.identifier == "showGoCookForVideo" {
            
        } else if segue.identifier == "showGoCookForVidup" {
            
        }
    }
}
