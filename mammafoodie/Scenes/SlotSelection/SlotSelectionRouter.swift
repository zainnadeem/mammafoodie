import UIKit

protocol SlotSelectionRouterInput {

}

class SlotSelectionRouter: SlotSelectionRouterInput {

    weak var viewController: SlotSelectionViewController!
    
    // MARK: - Navigation
    
    func passDataToNextScene(segue: UIStoryboardSegue) {
        // NOTE: Teach the router which scenes it can communicate with

    }
}
