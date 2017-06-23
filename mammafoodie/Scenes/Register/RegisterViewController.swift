import UIKit

protocol RegisterViewControllerInput {
    
}

protocol RegisterViewControllerOutput {
//    func RegisterAdapterTextSetup(_ textFeild:UITextField)
    func updateShadow()

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
    }
    
    
    func registerBtnSetup(){
        registerBtn.layer.cornerRadius = 23
        registerBtn.layer.borderWidth = 1
        registerBtn.layer.borderColor = UIColor.clear.cgColor
        registerBtn.clipsToBounds = true

    }
   
    // MARK: - Event handling
    
    // MARK: - Display logic
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.registerBtn.applyGradient(colors: [gradientStartColor, gradientEndColor])
    }
    
    
        
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        updateShadow()
//    }

    
}
