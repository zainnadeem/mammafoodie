import UIKit

protocol GoCookViewControllerInput {
    
}

protocol GoCookViewControllerOutput {
    func prepareOptions()
    func selectOption(option : GoCookOption)
    func showStep1()
    func showStep2()
}

typealias GoCookCompletion = () -> Void

enum GoCookOption {
    case LiveVideo, Vidups, Picture, None
}

class GoCookViewController: UIViewController, GoCookViewControllerInput {
    
    var output: GoCookViewControllerOutput!
    var router: GoCookRouter!
    
    var step2VC : GoCookStep2ViewController!
    
    var selectedOption : GoCookOption = .None {
        didSet {
            self.output.selectOption(option: self.selectedOption)
            self.step2VC.selectedOption = self.selectedOption
        }
    }
    
    @IBOutlet weak var btnStep1: UIButton!
    @IBOutlet weak var btnStep2: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var viewLiveVideo: UIView!
    @IBOutlet weak var lblLiveVideo: UILabel!
    @IBOutlet weak var btnLiveVideo: UIButton!
    
    @IBOutlet weak var viewVidups: UIView!
    @IBOutlet weak var lblVidups: UILabel!
    @IBOutlet weak var btnVidUps: UIButton!
    
    @IBOutlet weak var viewMenu: UIView!
    @IBOutlet weak var lblMenu: UILabel!
    @IBOutlet weak var btnMenu: UIButton!
    
    @IBOutlet var allViewOptions: [UIView]!
    @IBOutlet var allButtons: [UIButton]!
    
    @IBOutlet weak var viewStep1: UIView!
    @IBOutlet weak var conLeadingViewStep1: NSLayoutConstraint!
    @IBOutlet weak var viewStep2: UIView!
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        GoCookConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for childVC in self.childViewControllers {
            if childVC is GoCookStep2ViewController {
                self.step2VC = childVC as!GoCookStep2ViewController
            }
        }
        self.output.prepareOptions()
    }
    
    // MARK: - Event handling
    @IBAction func onVidUpTap(_ sender: UIButton) {
        self.selectedOption = .Vidups
        
    }
    
    @IBAction func onMenuTap(_ sender: UIButton) {
        self.selectedOption = .Picture
    }
    
    @IBAction func onLiveVideoTap(_ sender: UIButton) {
        self.selectedOption = .LiveVideo
    }
    
    @IBAction func onStep1(_ sender: UIButton) {
        self.output.showStep1()
    }
    
    @IBAction func onStep2(_ sender: UIButton) {
        self.output.showStep2()
    }
    
    @IBAction func onNext(_ sender: UIButton) {
        self.output.showStep2()
    }
    
    // MARK: - Display logic
}

extension UIViewController {
    func showAlert(_ title : String?, message : String?) {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (action) in
            
        }))
        self.present(alertController, animated: true) {
            
        }
    }
    
    func showAlert(_ title : String?, message : String?, actionTitle : String, actionStyle : UIAlertActionStyle, actionhandler : ((UIAlertAction) -> Swift.Void)? = nil) {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: actionTitle, style: actionStyle, handler: actionhandler))
        self.present(alertController, animated: true) {
            
        }
    }
    
}