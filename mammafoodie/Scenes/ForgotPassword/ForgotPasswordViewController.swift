import UIKit

protocol ForgotPasswordViewControllerInput {
    
}

protocol ForgotPasswordViewControllerOutput {
    func forgotpasswordWorker(email: String)
}

class ForgotPasswordViewController: UIViewController, ForgotPasswordViewControllerInput {
    
    var output: ForgotPasswordViewControllerOutput!
    var router: ForgotPasswordRouter!
    
    var email:String?
    
    @IBOutlet weak var txfEmail: UITextField!
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    let gradientStartColor : UIColor = UIColor.init(red: 1.0, green: 0.39, blue: 0.13, alpha: 1.0)
    let gradientEndColor : UIColor = UIColor.init(red: 1.0, green: 0.55, blue: 0.17, alpha: 1.0)
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ForgotPasswordConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txfEmail.text = self.email
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.btnSubmit.layer.cornerRadius = 23
        self.btnSubmit.clipsToBounds = true
        
        self.title = "Reset Password"
        
       
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
         self.btnSubmit.applyGradient(colors: [gradientStartColor,gradientEndColor], direction: .rightToLeft)
    }
    
    // MARK: - Event handling
    
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        
        guard self.txfEmail.text != nil else {return}
        
        output.forgotpasswordWorker(email: self.txfEmail.text!)
        
    }
    
    
    // MARK: - Display logic
    
}
