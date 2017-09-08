import UIKit
import MBProgressHUD
import Firebase

protocol GoCookViewControllerInput {
    
}

protocol GoCookViewControllerOutput {
    func prepareOptions()
    func selectOption(option : MFDishMediaType)
    func showStep1()
    func showStep2(_ animated: Bool)
}

typealias GoCookCompletion = (MFDish, UIImage?, URL?) -> Void

class GoCookViewController: UIViewController, GoCookViewControllerInput {
    
    var output: GoCookViewControllerOutput!
    var router: GoCookRouter!
    
    var hud = MBProgressHUD.init()
    
    var step2VC : GoCookStep2ViewController!
    
    var createdmedia : MFDish?
    
    var dishCreated: ((MFDish)->Void)?
    
    var selectedOption : MFDishMediaType = .unknown {
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
    //    @IBOutlet weak var viewStep2: UIView!
    
    var step2Shown: Bool = false
    
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
                self.step2VC = childVC as! GoCookStep2ViewController
                self.step2VC.completion = { (dish, image, videoPathURL) in
                    DispatchQueue.main.async {
                        self.create(dish, image: image, videoURL: videoPathURL)
                    }
                }
            }
        }
        self.output.prepareOptions()
        self.viewStep1.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let tmp = self.selectedOption
        self.selectedOption = tmp
        if self.selectedOption != .unknown && !self.step2Shown {
            self.step2Shown = true
            self.step2VC.clearData()
            self.output.showStep2(false)
        }
        self.viewStep1.isHidden = false
    }
    
    // MARK: - Event handling
    @IBAction func onVidUpTap(_ sender: UIButton) {
        self.selectedOption = .vidup
    }
    
    @IBAction func onMenuTap(_ sender: UIButton) {
        self.selectedOption = .picture
    }
    
    @IBAction func onLiveVideoTap(_ sender: UIButton) {
        self.selectedOption = .liveVideo
    }
    
    @IBAction func onStep1(_ sender: UIButton) {
        self.output.showStep1()
    }
    
    @IBAction func onStep2(_ sender: UIButton) {
        
    }
    
    @IBAction func onNext(_ sender: UIButton) {
        self.nextStep()
    }
    
    private func nextStep() {
        self.step2VC.clearData()
        self.output.showStep2(true)
    }
    
    
    // MARK: - Display logic
    func create(_ dish : MFDish, image : UIImage?, videoURL :  URL?) {
        dish.mediaType = self.selectedOption
        self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        switch self.selectedOption {
        case .liveVideo:
            Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
                AnalyticsParameterItemID: dish.id as NSObject,
                AnalyticsParameterItemName: "liveVideo" as NSObject,
                AnalyticsParameterContentType: "LiveVideoCreated" as NSObject
                ])
            dish.save { (error) in
                DispatchQueue.main.async {
                    self.selectedOption = .unknown
                    self.step2VC.clearData()
                    self.hud.hide(animated: true)
                    self.navigationController?.dismiss(animated: false, completion: {
                        self.dishCreated?(dish)
                    })
                }
            }
            
        case .picture:
            if let img = image {
                DatabaseGateway.sharedInstance.save(image: img, at: dish.getStoragePath(), completion: { (downloadURL, error) in
                    DispatchQueue.main.async {
                        self.saveDish(dish, mediaURL: downloadURL, error : error)
                    }
                })
            } else {
                self.hud.hide(animated: true)
                self.navigationController?.dismiss(animated: false, completion: {
                })
            }
            
        case .vidup:
            if let video = videoURL,
                let img = image {
                DatabaseGateway.sharedInstance.save(video: video, at: dish.getStoragePath(), completion: { (downloadURL, error) in
                    DatabaseGateway.sharedInstance.save(image: img, at: dish.getThumbPath(), completion: { (thumbURL, error) in
                        DispatchQueue.main.async {
                            dish.coverPicURL = thumbURL
                            self.saveDish(dish, mediaURL: downloadURL, error: error)
                        }
                    })
                })
            } else {
                self.hud.hide(animated: true)
                self.navigationController?.dismiss(animated: false, completion: {
                })
            }
            
        default:
            self.hud.hide(animated: true)
            self.navigationController?.dismiss(animated: false, completion: {
            })
            
        }
    }
    
    func saveDish(_ dish : MFDish, mediaURL : URL?, error : Error?) {
        if let url = mediaURL {
            dish.mediaURL = url
            dish.save { (errorFound) in
                DispatchQueue.main.async {
                    self.hud.hide(animated: true)
                    self.selectedOption = .unknown
                    //                self.onStep1(self.btnStep1)
                    self.step2VC.clearData()
                    if let er = errorFound {
                        self.showAlert(er.localizedDescription, message: nil)
                    } else {
                        // Success
                        self.navigationController?.dismiss(animated: false, completion: {
                            self.dishCreated?(dish)
                        })
                    }
                }
            }
        } else {
            self.hud.hide(animated: true)
            self.showAlert(error?.localizedDescription, message: nil)
            self.navigationController?.dismiss(animated: false, completion: {
            })
        }
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: {
            
        })
    }
    
}
