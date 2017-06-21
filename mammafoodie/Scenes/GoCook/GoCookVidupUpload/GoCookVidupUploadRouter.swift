import UIKit

protocol GoCookVidupUploadRouterInput {

}

class GoCookVidupUploadRouter: GoCookVidupUploadRouterInput {

    weak var viewController: GoCookVidupUploadViewController!
    
    // MARK: - Navigation
    
    func passDataToNextScene(segue: UIStoryboardSegue) {
        // NOTE: Teach the router which scenes it can communicate with

    }
}
