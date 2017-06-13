import UIKit
import SafariServices


protocol LoginViewControllerInput {
    func showLoginSuccessMessage(_ message: String)
    func showLogoutSuccessMessage(_ message: String)
    func present(_ viewController: UIViewController)
    func dismiss(_ viewController: UIViewController)
    func forgotpasswordWorker(success:String)
    func viewControllerToPresent() -> UIViewController
}

protocol LoginViewControllerOutput {
    func login(with email: String, password: String)
    func loginWithGoogle()
    func logoutWithGoogle()
    func forgotpasswordWorker(email: String)
    func loginWithFacebook()
    func logoutWithFacebook()
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
        
        /*
 
 // Add a custom login button to your app
 let myLoginButton = UIButton(type: .custom)
 myLoginButton.backgroundColor = UIColor.darkGray
 myLoginButton.frame = CGRect(x: 0, y: 200, width: 180, height: 40)
 myLoginButton.setTitle("My Login Button", for: .normal)
 
 // Handle clicks on the button
 myLoginButton.addTarget(self, action: #selector(self.loginButtonClicked), for: .touchUpInside)
 
 
 // Add a custom logout button to your app
 let myLogoutButton = UIButton(type: .custom)
 myLogoutButton.backgroundColor = UIColor.darkGray
 myLogoutButton.frame = CGRect(x: 0, y: 300, width: 180, height: 40)
 myLogoutButton.center = view.center
 myLogoutButton.setTitle("Logout", for: .normal)
 
 // Handle clicks on the button
 myLogoutButton.addTarget(self, action: #selector(self.logoutButtonClicked), for: .touchUpInside)
 
 
 // Add the button to the view
 view.addSubview(myLoginButton)
 view.addSubview(myLogoutButton)
 */
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


    func loginButtonClicked() {
        self.output.loginWithFacebook()
    }
    
    func logoutButtonClicked() {
        self.output.logoutWithFacebook()
    }
    
    
    func viewControllerToPresent() -> UIViewController {
        return self
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


