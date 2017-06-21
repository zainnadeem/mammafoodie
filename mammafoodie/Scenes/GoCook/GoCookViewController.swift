import UIKit

protocol GoCookViewControllerInput {
    
}

protocol GoCookViewControllerOutput {
    
}

typealias GoCookCompletion = () -> Void

let gradientStartColor : UIColor = UIColor.init(red: 1.0, green: 0.55, blue: 0.17, alpha: 1.0)
let gradientEndColor : UIColor = UIColor.init(red: 1.0, green: 0.39, blue: 0.13, alpha: 1.0)

let unselectedBackColor : UIColor = UIColor.init(red: 0.97, green: 0.97, blue: 0.98, alpha: 1.0)
let selectedBackColor : UIColor = .white

let selectedFont : UIFont? = UIFont.MontserratSemiBold(with: 17.0)
let unselectedFont : UIFont? = UIFont.MontserratLight(with: 16.0)

enum GoCookOption {
    case LiveVideo, Vidups, Picture, None
}

class GoCookViewController: UIViewController, GoCookViewControllerInput {
    
    var output: GoCookViewControllerOutput!
    var router: GoCookRouter!
    
    var liveVideoVC : GoCookLiveVideoUploadViewController?
    var vidupsVC : GoCookVidupUploadViewController?
    var pictureVC : GoCookPictureUploadViewController?
    
    
    var selectedOption : GoCookOption = .None {
        didSet {
            switch self.selectedOption {
            case .LiveVideo:
                self.selectView(self.viewLiveVideo)
                self.deselectView(self.viewVidups)
                self.deselectView(self.viewMenu)
                self.btnNext.applyGradient(colors: [gradientStartColor, gradientEndColor], direction: .leftToRight)
                break
                
            case .Vidups:
                self.selectView(self.viewVidups)
                self.deselectView(self.viewLiveVideo)
                self.deselectView(self.viewMenu)
                self.btnNext.applyGradient(colors: [gradientStartColor, gradientEndColor], direction: .leftToRight)
                break
                
            case .Picture:
                self.selectView(self.viewMenu)
                self.deselectView(self.viewLiveVideo)
                self.deselectView(self.viewVidups)
                self.btnNext.applyGradient(colors: [gradientStartColor, gradientEndColor], direction: .leftToRight)
                break
                
            default:
                self.deselectView(self.viewLiveVideo)
                self.deselectView(self.viewVidups)
                self.deselectView(self.viewMenu)
                self.btnNext.removeGradient()
                break
                
            }
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
        self.prepareOptions()
        self.onStep1(self.btnStep1)
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
        sender.isSelected = true
        self.btnStep2.isSelected = false
        self.showStep1()
    }
    
    @IBAction func onStep2(_ sender: UIButton) {
        switch self.selectedOption {
        case .LiveVideo:
            self.liveVideoVC?.removeFromParentViewController()
            self.liveVideoVC?.view.removeFromSuperview()
            
        case .Vidups:
            self.vidupsVC?.removeFromParentViewController()
            self.vidupsVC?.view.removeFromSuperview()
            
        case .Picture:
            self.pictureVC?.removeFromParentViewController()
            self.pictureVC?.view.removeFromSuperview()
            
        default:
            break
        }
        self.onNext(self.btnNext)
    }
    
    @IBAction func onNext(_ sender: UIButton) {
        self.btnStep1.isSelected = false
        self.btnStep2.isSelected = true
        switch self.selectedOption {
        case .LiveVideo:
            self.liveVideoVC = GoCookLiveVideoUploadViewController.addToParentViewController(self, completion: {
                
            })
            self.showStep2()
            
        case .Vidups:
            self.vidupsVC = GoCookVidupUploadViewController.addToParentViewController(self, completion: {
                
            })
            self.showStep2()
            
        case .Picture:
            self.pictureVC = GoCookPictureUploadViewController.addToParentViewController(self, completion: {
                
            })
            self.showStep2()
            
        default:
            break
        }
    }
    
    // MARK: - Display logic
    func prepareOptions() {
        for btn in self.allButtons {
            btn.imageView?.contentMode = .scaleAspectFit
        }
        
        for viewOption in self.allViewOptions {
            viewOption.removeGradient()
            viewOption.layer.cornerRadius = 5.0
            viewOption.clipsToBounds = true
        }
        self.btnNext.layer.cornerRadius = 26.0
        self.btnNext.clipsToBounds = true
    }
    
    func animate(_ animation :@escaping () -> Void) {
        UIView.animate(withDuration: 0.27, delay: 0, options: .curveEaseInOut, animations: animation) { (finished) in
            
        }
    }
    
    func selectView(_ viewSelected : UIView) {
        self.animate {
            viewSelected.backgroundColor = selectedBackColor
            viewSelected.addGradienBorder(colors: [gradientStartColor, gradientEndColor], direction: .leftToRight, borderWidth: 3.0, animated: true)
        }
        for subView in viewSelected.subviews {
            if let btn = subView as? UIButton {
                self.animate {
                    btn.isSelected = true
                }
            }
            
            if let lbl = subView as? UILabel {
                self.animate {
                    lbl.isHighlighted = true
                    if let font = selectedFont {
                        lbl.font = font
                    }
                }
            }
        }
    }
    
    func deselectView(_ viewSelected : UIView) {
        self.animate {
            viewSelected.removeGradient()
            viewSelected.backgroundColor = unselectedBackColor
        }
        for subView in viewSelected.subviews {
            if let btn = subView as? UIButton {
                self.animate {
                    btn.isSelected = false
                    btn.removeGradient()
                }
            }
            
            if let lbl = subView as? UILabel {
                self.animate {
                    lbl.isHighlighted = false
                    if let font = unselectedFont {
                        lbl.font = font
                    }
                }
            }
        }
    }
    
    func showStep2() {
        UIView.animate(withDuration: 0.27, delay: 0, options: .curveLinear, animations: {
            self.conLeadingViewStep1.constant = self.viewStep1.frame.size.width * -1
            self.view.layoutIfNeeded()
        }) { (finished) in
            
        }
    }
    
    func showStep1() {
        UIView.animate(withDuration: 0.27, delay: 0, options: .curveLinear, animations: {
            self.conLeadingViewStep1.constant = 0
            self.view.layoutIfNeeded()
        }) { (finished) in
            
        }
    }

    func start(_ meidaOption : GoCookOption) {
        self.selectedOption = meidaOption
        self.onNext(self.btnNext)
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
