import UIKit

protocol GoCookPictureUploadRouterInput {

}

class GoCookPictureUploadRouter: GoCookPictureUploadRouterInput {

    weak var viewController: GoCookPictureUploadViewController!
    
    // MARK: - Navigation
    
    func passDataToNextScene(segue: UIStoryboardSegue) {
        // NOTE: Teach the router which scenes it can communicate with

    }
}
