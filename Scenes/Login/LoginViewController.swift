import UIKit

protocol LoginViewControllerInput {
    func displaySomething(viewModel: Login.Something.ViewModel)
}

protocol LoginViewControllerOutput {
    func doSomething(request: Login.Something.Request)
}

class LoginViewController: UIViewController, LoginViewControllerInput {
    var output: LoginViewControllerOutput!
    var router: LoginRouter!
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        LoginConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doSomethingOnLoad()
    }
    
    // MARK: - Event handling
    
    func doSomethingOnLoad() {
        // NOTE: Ask the Interactor to do some work
        
        let request = Login.Something.Request()
        output.doSomething(request: request)
    }
    
    // MARK: - Display logic
    
    func displaySomething(viewModel: Login.Something.ViewModel) {
        // NOTE: Display the result from the Presenter
        
        // nameTextField.text = viewModel.name
    }
}
