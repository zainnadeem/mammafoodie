import UIKit
import SafariServices


protocol LoginViewControllerInput {
    func showLoginSuccessMessage(_ message: String)
}

protocol LoginViewControllerOutput {
    func login(with email: String, password: String)
}

class LoginViewController: UIViewController, LoginViewControllerInput, SFSafariViewControllerDelegate {
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
    @IBAction func btnPrivacyTapped(_ sender: Any) {
        router.openPrivacyPolicy()
        
        
    }
    
    @IBAction func btnTermsTapped(_ sender: Any) {
        router.openTermsAndConditions()
        
    }
    // MARK: - Inputs
    
    func showLoginSuccessMessage(_ message: String) {
        print(message)
    }
    
}

extension LoginViewController {
    
    enum ViewControllerSegue: String {
        case privacyPolicy = "OpenPrivacyPolicy"
        case terms = "OpenTerms"
        case unnamed = ""
    }
    
}


