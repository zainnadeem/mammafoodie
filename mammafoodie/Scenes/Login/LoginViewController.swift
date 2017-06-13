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
        router.openSafariVC(with: .privacyPolicy)
        
        
    }
    
    @IBAction func btnTermsTapped(_ sender: Any) {
        router.openSafariVC(with: .terms)
        
    }
    // MARK: - Inputs
    
    func showLoginSuccessMessage(_ message: String) {
        print(message)
    }
    
}

extension LoginViewController {
    
    enum ViewControllerSegue : String {
       case unnamed = ""
    }

    enum SafariAddresses: String {
        case privacyPolicy = "https://www.google.co.in/?gfe_rd=cr&ei=qjc6WdiRFrTv8we-zoTIDg"
        case terms = "https://swifting.io/blog/2016/09/07/architecture-wars-a-new-hope/"
    }
    
}


