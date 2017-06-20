import UIKit

protocol GoCookLiveVideoUploadRouterInput {

}

class GoCookLiveVideoUploadRouter: GoCookLiveVideoUploadRouterInput {

    weak var viewController: GoCookLiveVideoUploadViewController!
    
    // MARK: - Navigation
    
    func passDataToNextScene(segue: UIStoryboardSegue) {
        // NOTE: Teach the router which scenes it can communicate with

    }
}
