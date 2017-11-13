import UIKit

class MFNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.layer.borderWidth = 0
        
        let yourBackImage = UIImage(named: "BackBtn")
        self.navigationBar.backIndicatorImage = yourBackImage
        self.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationBar.backItem?.title = "B"
    }
}
