import UIKit

protocol LoginViewControllerInput {
    func showLoginSuccessMessage(_ message: String)
    func viewControllerToPresent() -> UIViewController
}

protocol LoginViewControllerOutput {
    func login(with email: String, password: String)
    func loginWithFacebook()
    func logoutWithFacebook()
}

class LoginViewController: UIViewController, LoginViewControllerInput{
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
