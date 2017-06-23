import UIKit
import SafariServices
import FirebaseAuth
import Alamofire

protocol LoginViewControllerInput {
    func showHomeScreen()
    func showAlert(alertController:UIAlertController)
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
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var passImageView: UIImageView!
    @IBOutlet weak var emailImageView: UIImageView!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var loginButn: UIButton!
    
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateShadow()
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
    
    
    //FireBase SignUP
    
    @IBAction func signUpWithFireBase(sender:UIButton){
        
        guard validateCredentials() else {return}
        
        let credentials = Login.Credentials(email: txtEmail.text!, password: txtPassword.text!)
        output.signUpWith(credentials: credentials)
    }
    
    @IBAction func loginWithFireBase(sender:UIButton){
        
        guard validateCredentials() else {return}
        
        let credentials = Login.Credentials(email: txtEmail.text!, password: txtPassword.text!)
        output.loginWith(credentials: credentials)
    }
    
    //Login with Facebook
    
    @IBAction func loginWithFacebook(sender:UIButton){
        output.loginWithFacebook()
    }
    
    
    //Login with Google
    @IBAction func loginWithGoogle(sender:UIButton){
        output.loginWithGoogle()
    }
    
    @IBAction func forgotPassword(sender:UIButton){
        
        guard self.txtEmail.text != nil else {return}
        
        output.forgotpasswordWorker(email: self.txtEmail.text!)
    }
    
    @IBAction func logout(sender:UIButton){
        
        //guard self.txtEmail.text != nil else {return}
        
        
        output.logout()
    }
    
    
    //Validations
    
    func validateCredentials() -> Bool{
        guard (txtEmail.text != nil && txtPassword.text != nil), !txtEmail.text!.isEmpty, !txtPassword.text!.isEmpty else {
            //Show alert
            return false
        }
        
        return true
    }
    
    
    
    // MARK: - Inputs
   
    func viewControllerToPresent() -> UIViewController {
        return self
    }
    
    func showHomeScreen() {
        
        let alertController = UIAlertController(title: "Success" , message: "Login successful. Navigate to home screen", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.showAlert(alertController: alertController)
    }
    
    func showAlert(alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
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


