import UIKit

protocol LocationSearchRouterInput {

}

class LocationSearchRouter: LocationSearchRouterInput {

    weak var viewController: LocationSearchViewController!
    
    // MARK: - Navigation
    
    func passDataToNextScene(segue: UIStoryboardSegue) {
        // NOTE: Teach the router which scenes it can communicate with

    }
}
