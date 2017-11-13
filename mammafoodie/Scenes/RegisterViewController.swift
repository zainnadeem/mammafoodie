import UIKit

protocol RegisterViewControllerInput {
    
}

protocol RegisterViewControllerOutput {
    
}

class RegisterViewController: UIViewController, RegisterViewControllerInput {
    
    var output: RegisterViewControllerOutput!
    var router: RegisterRouter!
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        RegisterConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Event handling
    
    // MARK: - Display logic
    
}
