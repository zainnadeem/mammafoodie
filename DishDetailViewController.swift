import UIKit

protocol DishDetailViewControllerInput {
    
}

protocol DishDetailViewControllerOutput {
    
}

class DishDetailViewController: UIViewController, DishDetailViewControllerInput {
    
    var output: DishDetailViewControllerOutput!
    var router: DishDetailRouter!
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DishDetailConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Event handling
    
    // MARK: - Display logic
    
}
