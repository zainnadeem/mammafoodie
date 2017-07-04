import UIKit

class MFNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.layer.borderWidth = 0
    }
}
