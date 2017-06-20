import UIKit

protocol VidupDetailPageRouterInput {

}

class VidupDetailPageRouter: VidupDetailPageRouterInput {

    weak var viewController: VidupDetailPageViewController!
    
    // MARK: - Navigation
    
    func passDataToNextScene(segue: UIStoryboardSegue) {
        // NOTE: Teach the router which scenes it can communicate with

    }
}
