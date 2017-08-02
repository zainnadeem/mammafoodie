import UIKit

protocol RegisterViewControllerInput {
    
}

protocol RegisterViewControllerOutput {
    //    func RegisterAdapterTextSetup(_ textFeild:UITextField)
    func updateShadow()
    func register(name: String, email: String, password: String)
}

class RegisterViewController: UIViewController, RegisterViewControllerInput , UITextFieldDelegate{
    
    var output: RegisterViewControllerOutput!
    var router: RegisterRouter!
    
    // MARK: - Object lifecycle
    @IBOutlet weak var passImageView: UIImageView!
    @IBOutlet weak var emailImageView: UIImageView!
    @IBOutlet weak var nameImageView: UIImageView!
    
    @IBOutlet weak var emailTextFeild: UITextField!
    @IBOutlet weak var passTextFeild: UITextField!
    
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var viewNameIcon: UIView!
    
    @IBOutlet weak var viewPasswordIcon: UIView!
    @IBOutlet weak var viewEmailIcon: UIView!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    lazy var RegisterAdapterTextfeild = RegisterAdapter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        RegisterConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.RegisterAdapterTextfeild.nameTextField = self.nameTextField
        self.RegisterAdapterTextfeild.emailTextFeild = self.emailTextFeild
        self.RegisterAdapterTextfeild.passTextFeild = self.passTextFeild
        self.RegisterAdapterTextfeild.nameImageView = self.nameImageView
        self.RegisterAdapterTextfeild.emailImageView = self.emailImageView
        self.RegisterAdapterTextfeild.passImageView = self.passImageView
        self.RegisterAdapterTextfeild.viewNameIcon = self.viewNameIcon
        self.RegisterAdapterTextfeild.viewEmailIcon = self.viewEmailIcon
        self.RegisterAdapterTextfeild.viewPasswordIcon = self.viewPasswordIcon
        registerBtnSetup()
        self.RegisterAdapterTextfeild.setupTextfeildView()
        output.updateShadow()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    func registerBtnSetup(){
        registerBtn.layer.cornerRadius = 23
        registerBtn.layer.borderWidth = 1
        registerBtn.layer.borderColor = UIColor.clear.cgColor
        registerBtn.clipsToBounds = true
    }
    
    // MARK: - Event handling
    
    // MARK: - Display logic
    
    func showAlert(alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.registerBtn.applyGradient(colors: [gradientStartColor, gradientEndColor])
    }
    
    @IBAction func registerBtn(_ sender: Any) {
        guard validateCredentials() && isValidEmail(emailStr: emailTextFeild.text!) else {
            return
        }
        self.output.register(name: nameTextField.text!, email: emailTextFeild.text!, password:  passTextFeild.text!)
    }
    
    func validateCredentials() -> Bool{
        guard (emailTextFeild.text != nil && passTextFeild.text != nil && nameTextField.text != ""), !emailTextFeild.text!.isEmpty, !passTextFeild.text!.isEmpty, !nameTextField.text!.isEmpty else {
            let alertController = UIAlertController(title: "Error" , message: "Please enter the login credentials.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.showAlert(alertController: alertController)
            return false
        }
        
        return true
    }
    
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*_+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        if !emailTest.evaluate(with: emailStr) {
            
            let alertController = UIAlertController(title: "Error" , message: "The email entered is not in a valid format.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.showAlert(alertController: alertController)
            
            return false
        }
        
        return true
    }
    
    func navigateHomePage() {
        AppDelegate.shared().setHomeViewController()
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //        updateShadow()
    //    }
    
    
}
