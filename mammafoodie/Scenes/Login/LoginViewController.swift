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

class LoginViewController: UIViewController, LoginViewControllerInput, SFSafariViewControllerDelegate, UITextFieldDelegate {
    var output: LoginViewControllerOutput!
    var router: LoginRouter!
    
    let gradientStartColor : UIColor = UIColor.init(red: 1.0, green: 0.39, blue: 0.13, alpha: 1.0)
    let gradientEndColor : UIColor = UIColor.init(red: 1.0, green: 0.55, blue: 0.17, alpha: 1.0)
    
    var shapeLayer: CAShapeLayer!
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var passImageView: UIImageView!
    @IBOutlet weak var emailImageView: UIImageView!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var loginButn: UIButton!
    
    
    // MARK: - Object lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        LoginConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        //        logoutGmailButn()
        //        forgotPasswordButn()
        
        self.loginButn.layer.cornerRadius = 23
        self.loginButn.clipsToBounds = true
        userView.layer.cornerRadius = 5
        userView.layer.borderWidth = 1
        userView.layer.borderColor = UIColor.clear.cgColor
        
        passwordView.layer.cornerRadius = 5
        passwordView.layer.borderWidth = 1
        passwordView.layer.borderColor = UIColor.clear.cgColor
        self.txtPassword.delegate = self
        self.txtEmail.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        updateShadow()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.loginButn.applyGradient(colors: [gradientStartColor, gradientEndColor])
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
        self.router.openSafariVC(with: .privacyPolicy)
    }
    
    @IBAction func btnTermsTapped(_ sender: Any) {
        self.router.openSafariVC(with: .terms)
    }
    // MARK: - Inputs
    func showLoginSuccessMessage(_ message: String) {
        print(message)
    }
    func showLogoutSuccessMessage(_ message: String) {
        // print(message)
    }
    
    func forgotpasswordWorker(success:String) {
        let alert = UIAlertController(title: "Alert", message: success, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateShadow() {
        if self.shapeLayer == nil {
            self.self.loginButn.superview?.layoutIfNeeded()
            self.shapeLayer = CAShapeLayer()
            self.shapeLayer.shadowColor = #colorLiteral(red: 1, green: 0.7725490196, blue: 0.6, alpha: 0.7041212248).cgColor
            self.shapeLayer.shadowOpacity = 70.0
            self.shapeLayer.shadowRadius = 7
            
            var shadowFrame: CGRect = self.loginButn.frame
            shadowFrame.origin.x -= -30
            shadowFrame.origin.y += 17
            shadowFrame.size.width += -60
            shadowFrame.size.height -= 8
            
            self.shapeLayer.shadowPath = UIBezierPath(roundedRect: shadowFrame, cornerRadius: self.loginButn.layer.cornerRadius).cgPath
            self.shapeLayer.shadowOffset = CGSize(width: 0, height: 1)
            
            self.loginButn.superview?.layer.insertSublayer(self.shapeLayer, at: 0)
        }
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
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.txtEmail {
            self.emailImageView.image = UIImage(named: "selectuser")
        }
        if textField == self.txtPassword {
            self.passImageView.image = UIImage(named: "passselect")
        }
    }
    
    @IBAction func btnLoginWithFacebookTapped(_ sender: UIButton) {
        self.output.loginWithFacebook()
    }
    
    @IBAction func btnLoginWithGoogleTapped(_ sender: UIButton) {
        self.output.loginWithGoogle()
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


