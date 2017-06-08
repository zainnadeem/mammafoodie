import UIKit

protocol LoginViewControllerInput {
    func showLoginSuccessMessage(_ message: String)
    func showLogoutSuccessMessage(_ message: String)
    func present(_ viewController: UIViewController)
    func dismiss(_ viewController: UIViewController)
}

protocol LoginViewControllerOutput {
    func login(with email: String, password: String)
    func loginWithGoogle()
    func logoutWithGoogle()
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
        logoutGmailButn()
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
    
    // MARK: - Inputs
    func showLoginSuccessMessage(_ message: String) {
       // print(message)
    }
    func showLogoutSuccessMessage(_ message: String) {
       // print(message)
    }

    
    func logoutGmailButn() {
        let logoutGmail = UIButton(type: .custom) as UIButton
        logoutGmail.backgroundColor = .blue
        logoutGmail.setTitle("Logout", for: .normal)
        logoutGmail.frame = CGRect(x: 30, y: 120, width: 100, height: 40)
        logoutGmail.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(logoutGmail)

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
