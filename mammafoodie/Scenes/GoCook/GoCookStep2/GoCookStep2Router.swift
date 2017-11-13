import UIKit

protocol GoCookStep2RouterInput {

}

class GoCookStep2Router: GoCookStep2RouterInput {

    weak var viewController: GoCookStep2ViewController!
    
    // MARK: - Navigation
    
    func passDataToNextScene(segue: UIStoryboardSegue) {
        // NOTE: Teach the router which scenes it can communicate with

    }
}
