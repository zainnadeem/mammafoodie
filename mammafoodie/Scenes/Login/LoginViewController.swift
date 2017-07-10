import UIKit
import SafariServices
import FirebaseAuth
import Alamofire
import KLCPopup

protocol LoginViewControllerInput {
    func showHomeScreen()
    func viewControllerToPresent() -> UIViewController
}

protocol LoginViewControllerOutput {
    func signUpWith(credentials:Login.Credentials)
    func loginWith(credentials:Login.Credentials)
    func loginWithGoogle()
    func forgotpasswordWorker(email: String)
    func loginWithFacebook()
    func logout()
}

class LoginViewController: UIViewController, LoginViewControllerInput, SFSafariViewControllerDelegate, UITextFieldDelegate {
    var output: LoginViewControllerOutput!
    var router: LoginRouter!
    
    let gradientStartColor : UIColor = UIColor.init(red: 1.0, green: 0.39, blue: 0.13, alpha: 1.0)
    let gradientEndColor : UIColor = UIColor.init(red: 1.0, green: 0.55, blue: 0.17, alpha: 1.0)
    
    var shapeLayer: CAShapeLayer!
    
    var activityIndicatorView:UIView?
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var passImageView: UIImageView!
    @IBOutlet weak var emailImageView: UIImageView!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var loginButn: UIButton!
    
    
    @IBOutlet var forgotPasswordPopup: UIView!
    
    @IBOutlet weak var txfForgotPassword: UITextField!
    
    @IBOutlet weak var btnForgotPasswordSubmit: UIButton!
    
    var KLCforgotPasswordPopup:KLCPopup?
    
    
    // MARK: - Object lifecycle
    override func awakeFromNib(){
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
        
        self.btnForgotPasswordSubmit.layer.cornerRadius = 22.5
        self.btnForgotPasswordSubmit.clipsToBounds = true
        
        self.forgotPasswordPopup.layer.cornerRadius = 3
        self.forgotPasswordPopup.clipsToBounds = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateShadow()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.loginButn.applyGradient(colors: [gradientStartColor, gradientEndColor],direction: .rightToLeft)
    }
    
    // MARK: - Event handling
    
    @IBAction func btnPrivacyTapped(_ sender: Any) {
        self.router.openSafariVC(with: .privacyPolicy)
    }
    
    @IBAction func btnTermsTapped(_ sender: Any) {
        self.router.openSafariVC(with: .terms)
    }
    
    
    @IBAction func forgotPasswordClicked(_ sender: UIButton) {
        
        
        let forgotPasswordVC = self.forgotPasswordPopup
        forgotPasswordVC?.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width - 40, height: 260)
        
        
        KLCforgotPasswordPopup = KLCPopup.init(contentView: forgotPasswordVC, showType: .bounceInFromTop , dismissType: .bounceOutToTop , maskType: .dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)
        
        KLCforgotPasswordPopup?.show(atCenter:CGPoint(x: self.view.center.x, y: self.view.center.y - 130) , in: self.view)
        
        
        txfForgotPassword.text = txtEmail.text
        txfForgotPassword.becomeFirstResponder()
        
        
    }
    
    
    @IBAction func forgotPasswordSubmitButtonClicked(_ sender: UIButton) {
        
        
        guard self.txfForgotPassword.text != nil && self.txfForgotPassword.text != "" else {return}
        
        output.forgotpasswordWorker(email: self.txfForgotPassword.text!)
        
        KLCforgotPasswordPopup?.dismiss(true)
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
            shadowFrame.origin.y += 30
            shadowFrame.size.width += -60
            shadowFrame.size.height -= 8
            
            self.shapeLayer.shadowPath = UIBezierPath(roundedRect: shadowFrame, cornerRadius: self.loginButn.layer.cornerRadius).cgPath
            self.shapeLayer.shadowOffset = CGSize(width: 0, height: 1)
            
            self.loginButn.superview?.layer.insertSublayer(self.shapeLayer, at: 0)
        }
    }
    
    
    //FireBase SignUP
    
    @IBAction func signUpWithFireBase(sender:UIButton){
        
        guard validateCredentials() else {return}
        
        let credentials = Login.Credentials(email: txtEmail.text!, password: txtPassword.text!)
        output.signUpWith(credentials: credentials)
        
        
    }
    
    @IBAction func loginWithFireBase(sender:UIButton){
        
        guard validateCredentials() && isValidEmail(emailStr: txtEmail.text!) else {return}
        
        let credentials = Login.Credentials(email: txtEmail.text!, password: txtPassword.text!)
        output.loginWith(credentials: credentials)
        
    }
    
    
    
    @IBAction func logout(sender:UIButton){
        output.logout()
        
    }
    
    
    @IBAction func btnLoginWithFacebookTapped(_ sender: UIButton) {
        self.output.loginWithFacebook()
        
    }
    
    @IBAction func btnLoginWithGoogleTapped(_ sender: UIButton) {
        self.output.loginWithGoogle()
    }
    
    
    
    //Validations
    
    func validateCredentials() -> Bool{
        guard (txtEmail.text != nil && txtPassword.text != nil), !txtEmail.text!.isEmpty, !txtPassword.text!.isEmpty else {
            
            let alertController = UIAlertController(title: "Error" , message: "Please enter the login credentials.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        if !emailTest.evaluate(with: emailStr) {
            
            let alertController = UIAlertController(title: "Error" , message: "The email entered is not in a valid format.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
            return false
        }
        
        return true
    }
    
    
    
    // MARK: - Inputs
    
    func viewControllerToPresent() -> UIViewController {
        return self
    }
    
    func showHomeScreen() {
        if let currentUser = Auth.auth().currentUser {
            AppDelegate.shared().setHomeViewController()
            
            let user: MFUser = MFUser()
            user.id = currentUser.uid
            user.name = currentUser.displayName
            user.email = currentUser.email
            
            DatabaseGateway.sharedInstance.createUserEntity(with: user, { _ in
                print("User created")
            })
            
            //            DatabaseGateway.sharedInstance.getUserWith(userID: currentUser.uid, { (user) in
            //                if let user = user {
            //                    user.name = "nithin"
            //                    user.email = "nithintest@gmail.com"
            //
            //                    DatabaseGateway.sharedInstance.updateUserEntity(with: user, { (errorMessage) in
            //                        if errorMessage != nil {
            //                            print("Error updating profile")
            //                        }
            //                    })
            //                }
            //            })
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.txtEmail {
            self.emailImageView.image = UIImage(named: "selectuser")
        }
        if textField == self.txtPassword {
            self.passImageView.image = UIImage(named: "passselect")
        }
    }
    
    
    //Routing
    
    
    
    
    
    
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


