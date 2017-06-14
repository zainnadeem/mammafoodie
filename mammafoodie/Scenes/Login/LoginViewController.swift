import UIKit
import SafariServices
import FirebaseAuth


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
}

class LoginViewController: UIViewController, LoginViewControllerInput, SFSafariViewControllerDelegate {
    var output: LoginViewControllerOutput!
    var router: LoginRouter!
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    
    
    // MARK: - Object lifecycle
    override func awakeFromNib(){
        super.awakeFromNib()
        LoginConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        logoutGmailButn()
//        forgotPasswordButn()
        
        
        if let currentUser = Auth.auth().currentUser{
            print("\(String(describing: currentUser.displayName)) is logged in already")
        }
        
        
 
         // Add a custom login button to your app
         let facebookLoginButton = UIButton(type: .custom)
         facebookLoginButton.backgroundColor = UIColor.darkGray
         facebookLoginButton.frame = CGRect(x: 30, y: 200, width: 180, height: 40)
         facebookLoginButton.setTitle("Login with Facebook", for: .normal)
         
          //Handle clicks on the button
         facebookLoginButton.addTarget(self, action: #selector(self.loginWithFacebook(sender:)), for: .touchUpInside)
         
         
         // Add a custom logout button to your app
         let googleLoginButton = UIButton(type: .custom)
         googleLoginButton.backgroundColor = UIColor.darkGray
         googleLoginButton.frame = CGRect(x: 30, y: 300, width: 180, height: 40)
         //googleLoginButton.center = view.center
         googleLoginButton.setTitle("Login with Google", for: .normal)
         
         // Handle clicks on the button
         googleLoginButton.addTarget(self, action: #selector(self.loginWithGoogle(sender:)), for: .touchUpInside)
        
        
        // Add a custom logout button to your app
        let fireBaseSignUpButton = UIButton(type: .custom)
        fireBaseSignUpButton.backgroundColor = UIColor.darkGray
        fireBaseSignUpButton.frame = CGRect(x: 30, y: 400, width: 180, height: 40)
        //fireBaseSignUpButton.center = view.center
        fireBaseSignUpButton.setTitle("Firebase Signup", for: .normal)
        
        // Handle clicks on the button
        fireBaseSignUpButton.addTarget(self, action: #selector(self.signUpWithFireBase(sender:)), for: .touchUpInside)
        
        
        // Add a custom logout button to your app
        let firebaseLoginButton = UIButton(type: .custom)
        firebaseLoginButton.backgroundColor = UIColor.darkGray
        firebaseLoginButton.frame = CGRect(x: 30, y: 500, width: 180, height: 40)
        //firebaseLoginButton.center = view.center
        firebaseLoginButton.setTitle("Firebase Login", for: .normal)
        
        // Handle clicks on the button
        firebaseLoginButton.addTarget(self, action: #selector(self.loginWithFireBase(sender:)), for: .touchUpInside)
         
         // Add the button to the view
         view.addSubview(facebookLoginButton)
         view.addSubview(googleLoginButton)
         view.addSubview(fireBaseSignUpButton)
         view.addSubview(firebaseLoginButton)
 
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
        print("Login successful. Navigate to home screen")
    }
    
    func showAlert(alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
    }
    
  
    
    

//    func forgotpasswordWorker(success:String) {
//        let alert = UIAlertController(title: "Alert", message: success, preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }

    
//    func logoutGmailButn() {
//        let logoutGmail = UIButton(type: .custom) as UIButton
//        logoutGmail.backgroundColor = .blue
//        logoutGmail.setTitle("Logout", for: .normal)
//        logoutGmail.frame = CGRect(x: 30, y: 120, width: 100, height: 40)
//        logoutGmail.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
//        self.view.addSubview(logoutGmail)
//    }
//    
//
//    func forgotPasswordButn() {
//       
//        let forgotPassword = UIButton(type: .custom) as UIButton
//        forgotPassword.backgroundColor = .blue
//        forgotPassword.setTitle("ForgotPassword", for: .normal)
//        forgotPassword.frame = CGRect(x: 100, y: 180, width: 150, height: 35)
//        forgotPassword.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
//        self.view.addSubview(forgotPassword)
//    }
//    
//    func buttonTapped(sender: UIButton){
//        self.output.forgotpasswordWorker(email: self.txtEmail.text!)
//    }

    
//    func buttonAction(sender: UIButton!) {
//        self.output.logoutWithGoogle()
//    }
    
//    func present(_ viewController: UIViewController) {
//        self.present(viewController, animated: true, completion: nil)
//    }
//   
//    func dismiss(_ viewController: UIViewController) {
//        self.dismiss(animated: true, completion: nil)
//    }


//    func loginButtonClicked() {
//        self.output.loginWithFacebook()
//    }
//    
//    func logoutButtonClicked() {
//        self.output.logoutWithFacebook()
//    }
 
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


