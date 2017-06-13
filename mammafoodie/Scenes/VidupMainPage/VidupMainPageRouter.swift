import UIKit

protocol VidupMainPageRouterInput {
    
}

class VidupMainPageRouter: VidupMainPageRouterInput {
    
    weak var viewController: VidupMainPageViewController!
    
    // MARK: - Navigation
    
    func passDataToNextScene(segue: UIStoryboardSegue) {
        // NOTE: Teach the router which scenes it can communicate with
        
    }
}
