import UIKit

protocol GoCookViewControllerInput {
    
}

protocol GoCookViewControllerOutput {
    
}

class GoCookViewController: UIViewController, GoCookViewControllerInput {
    
    var output: GoCookViewControllerOutput!
    var router: GoCookRouter!
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnLiveVideo: UIButton!
    @IBOutlet weak var btnVidUps: UIButton!
    @IBOutlet weak var btnMenu: UIButton!
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        GoCookConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareOptions()
    }
    
    // MARK: - Event handling
    @IBAction func onVidUpTap(_ sender: UIButton) {
        self.selectOption(sender)
        self.unselectOption(self.btnMenu)
        self.unselectOption(self.btnLiveVideo)
    }
    
    @IBAction func onMenuTap(_ sender: UIButton) {
        self.selectOption(sender)
        self.unselectOption(self.btnVidUps)
        self.unselectOption(self.btnLiveVideo)
    }
    
    @IBAction func onLiveVideoTap(_ sender: UIButton) {
        self.selectOption(sender)
        self.unselectOption(self.btnVidUps)
        self.unselectOption(self.btnMenu)
    }
    
    // MARK: - Display logic
    func prepareOptions() {
        
        self.btnLiveVideo.set(image: #imageLiteral(resourceName: "iconLive_Video_Unselected"), title: "Live Video", titlePosition: .bottom, additionalSpacing: 5, state: .normal)
        self.btnLiveVideo.set(image: #imageLiteral(resourceName: "iconLive_Video_Selected"), title: "Live Video", titlePosition: .bottom, additionalSpacing: 5, state: .selected)
        
        self.btnVidUps.set(image: #imageLiteral(resourceName: "iconVidups_Unselected"), title: "Vidups", titlePosition: .bottom, additionalSpacing: 15, state: .normal)
        self.btnVidUps.set(image: #imageLiteral(resourceName: "iconVidups_Selected"), title: "Vidups", titlePosition: .bottom, additionalSpacing: 15, state: .selected)
        
        self.btnMenu.set(image: #imageLiteral(resourceName: "iconMenu_Unselected"), title: "Menu", titlePosition: .bottom, additionalSpacing: 25, state: .normal)
        self.btnMenu.set(image: #imageLiteral(resourceName: "iconMenu_Selected"), title: "Menu", titlePosition: .bottom, additionalSpacing: 25, state: .selected)
        
    }
    
    func selectOption(_ button : UIButton) {
        button.isSelected = true
    }
    
    func unselectOption(_ button : UIButton) {
        button.isSelected = false
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
