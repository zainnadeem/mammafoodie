import UIKit

protocol LoginViewControllerInput {
    func showLoginSuccessMessage(_ message: String)
}

protocol LoginViewControllerOutput {
    func login(with email: String, password: String)
}

class LoginViewController: UIViewController, LoginViewControllerInput {
    var output: LoginViewControllerOutput!
    var router: LoginRouter!
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        LoginConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Event handling
    
    @IBAction func btnLoginTapped(_ sender: UIButton) {
        if self.txtEmail.text?.isEmpty == true {
            return
        }
        if self.txtPassword.text?.isEmpty == true {
            return
        }
        self.output.login(with: self.txtEmail.text!, password: self.txtPassword.text!)
    }
    
    // MARK: - Inputs
    
    func showLoginSuccessMessage(_ message: String) {
        print(message)
    }
}
