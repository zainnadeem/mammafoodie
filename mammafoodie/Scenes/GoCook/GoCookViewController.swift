import UIKit

protocol GoCookViewControllerInput {
    
}

protocol GoCookViewControllerOutput {
    func prepareOptions()
    func selectOption(option : MFDishMediaType)
    func showStep1()
    func showStep2()
}

typealias GoCookCompletion = (MFDish, UIImage?, URL?) -> Void

class GoCookViewController: UIViewController, GoCookViewControllerInput {
    
    var output: GoCookViewControllerOutput!
    var router: GoCookRouter!
    
    var step2VC : GoCookStep2ViewController!
    
    var createdmedia : MFMedia?
    
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
                self.step2VC.completion = { (dish, image, videoPathURL) in
                    DispatchQueue.main.async {
                        self.create(dish, image: image, videoURL: videoPathURL)
                    }
                }
            }
        }
        self.output.prepareOptions()
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
        self.step2VC.clearData()
        self.output.showStep2()
    }
    
    
    // MARK: - Display logic
    func create(_ dish : MFDish, image : UIImage?, videoURL :  URL?) {
        dish.mediaType = self.selectedOption
        switch self.selectedOption {
        case .liveVideo:
            dish.save { (error) in
                self.showAlert(error?.localizedDescription, message: nil)
            }
            
        case .picture:
            if let img = image {
                DatabaseGateway.sharedInstance.save(image: img, at: dish.getStoragePath(), completion: { (downloadURL, error) in
                    if let url = downloadURL {
                        self.saveDish(dish, mediaURL: url)
                    } else {
                        DispatchQueue.main.async {
                            self.showAlert(error?.localizedDescription, message: nil)
                        }
                    }
                })
            }
            
        case .vidup:
            if let video = videoURL {
                DatabaseGateway.sharedInstance.save(video: video, at: dish.getStoragePath(), completion: { (downloadURL, error) in
                    if let url = downloadURL {
                        self.saveDish(dish, mediaURL: url)
                    } else {
                        DispatchQueue.main.async {
                            self.showAlert(error?.localizedDescription, message: nil)
                        }
                    }
                })
            }
            
        default:
            break
        }
    }
    
    func saveDish(_ dish : MFDish, mediaURL : URL) {
        dish.mediaURL = mediaURL
        dish.save { (error) in
            DispatchQueue.main.async {
                if let er = error {
                    self.showAlert(er.localizedDescription, message: nil)
                } else {
                    self.showAlert("Dish Saved", message: "")
                }
                self.selectedOption = .unknown
                self.onStep1(self.btnStep1)
                self.step2VC.clearData()
            }
        }
    }
}
