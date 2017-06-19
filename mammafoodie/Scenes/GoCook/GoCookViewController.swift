import UIKit

protocol GoCookViewControllerInput {
    
}

protocol GoCookViewControllerOutput {
    
}

class GoCookViewController: UIViewController, GoCookViewControllerInput {
    
    var output: GoCookViewControllerOutput!
    var router: GoCookRouter!
    
    @IBOutlet weak var txtDishName: UITextField!
    @IBOutlet weak var txtViewDescription: UITextView!
    @IBOutlet weak var txtSlotsNo: UITextField!
    @IBOutlet weak var txtPricePerSlot: UITextField!
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        GoCookConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtViewDescription.layer.borderColor = UIColor.init(white: 0.9, alpha: 1).cgColor
        self.txtViewDescription.layer.borderWidth = 1.0
        self.txtViewDescription.layer.cornerRadius = 5.0
        self.txtViewDescription.clipsToBounds = true
    }
    
    // MARK: - Event handling
    
    // MARK: - Display logic
    @IBAction func onVidUpTap(_ sender: Any) {
        MediaPicker.pickVideo(on: self) { (videoPath, error) in
            if let err = error {
                self.showAlert(err.localizedDescription, message: nil)
            }
        }
    }
    
    @IBAction func onPictureTap(_ sender: Any) {
        self.showAlert("Show Picture Upload Screen", message: nil)
    }
    
    @IBAction func onLiveVideoTap(_ sender: Any) {
        self.showAlert("Start Live Video", message: nil)
    }
    
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
