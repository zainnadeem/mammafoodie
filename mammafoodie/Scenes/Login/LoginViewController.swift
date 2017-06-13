import UIKit
import SafariServices


protocol LoginViewControllerInput {
    func showLoginSuccessMessage(_ message: String)
    func showLogoutSuccessMessage(_ message: String)
    func present(_ viewController: UIViewController)
    func dismiss(_ viewController: UIViewController)
    func forgotpasswordWorker(success:String)
}

protocol LoginViewControllerOutput {
    func login(with email: String, password: String)
    func loginWithGoogle()
    func logoutWithGoogle()
    func forgotpasswordWorker(email: String)
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
        logoutGmailButn()
        forgotPasswordButn()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Event handling 
    @IBAction func btnLoginTapped(_ sender: UIButton) {
        self.output.loginWithGoogle()
//        if self.txtEmail.text?.isEmpty == true {
//            return
//        }
//        if self.txtPassword.text?.isEmpty == true {
//            return
//        }
//        self.output.login(with: self.txtEmail.text!, password: self.txtPassword.text!)
  
    }
    @IBAction func btnPrivacyTapped(_ sender: Any) {
        router.openSafariVC(with: .privacyPolicy)

        
    }
    
    @IBAction func btnTermsTapped(_ sender: Any) {
        router.openSafariVC(with: .terms)
        
    }
    // MARK: - Inputs
    func showLoginSuccessMessage(_ message: String) {
       // print(message)
    }
    func showLogoutSuccessMessage(_ message: String) {
       // print(message)
    }

    func forgotpasswordWorker(success:String) {
        let alert = UIAlertController(title: "Alert", message: success, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
    func logoutGmailButn() {
        let logoutGmail = UIButton(type: .custom) as UIButton
        logoutGmail.backgroundColor = .blue
        logoutGmail.setTitle("Logout", for: .normal)
        logoutGmail.frame = CGRect(x: 30, y: 120, width: 100, height: 40)
        logoutGmail.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(logoutGmail)
    }
    

    func forgotPasswordButn() {
       
        let forgotPassword = UIButton(type: .custom) as UIButton
        forgotPassword.backgroundColor = .blue
        forgotPassword.setTitle("ForgotPassword", for: .normal)
        forgotPassword.frame = CGRect(x: 100, y: 180, width: 150, height: 35)
        forgotPassword.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        self.view.addSubview(forgotPassword)
    }
    
    func buttonTapped(sender: UIButton){
        self.output.forgotpasswordWorker(email: self.txtEmail.text!)
    }
    
    func buttonAction(sender: UIButton!) {
        self.output.logoutWithGoogle()
    }
    
    func present(_ viewController: UIViewController) {
        self.present(viewController, animated: true, completion: nil)
    }
   
    func dismiss(_ viewController: UIViewController) {
        self.dismiss(animated: true, completion: nil)
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


