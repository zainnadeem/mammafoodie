import UIKit

protocol GoCookVidupUploadViewControllerInput {
    
}

protocol GoCookVidupUploadViewControllerOutput {
    
}

fileprivate enum VideoAction {
    case Upload, Shoot, None
}


class GoCookVidupUploadViewController: UIViewController, GoCookVidupUploadViewControllerInput {
    
    var output: GoCookVidupUploadViewControllerOutput!
    var router: GoCookVidupUploadRouter!
    
    var mediaPicker : MediaPicker?
    
    var cuisinesAdapter : CuisineCollectionViewAdapter = CuisineCollectionViewAdapter()
    
    var numberOfServings : UInt = 0
    
    fileprivate var selectedOption : VideoAction = .None {
        didSet {
            switch self.selectedOption {
            case .Upload:
                self.selectView(self.viewUploadVideo)
                self.deselectView(self.viewShootVideo)
                break
                
            case .Shoot:
                self.selectView(self.viewShootVideo)
                self.deselectView(self.viewUploadVideo)
                break
                
            default:
                self.deselectView(self.viewUploadVideo)
                self.deselectView(self.viewShootVideo)
                break
                
            }
        }
    }
    
    var completion : GoCookCompletion?
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var btnDietVeg: UIButton!
    @IBOutlet weak var btnDietNonVeg: UIButton!
    @IBOutlet weak var btnDietVegan: UIButton!
    
    @IBOutlet weak var cuisineCollectionView: UICollectionView!
    
    @IBOutlet weak var txtPreparationTime: UITextField!
    @IBOutlet var pickerPreparationTime: UIDatePicker!
    
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var lblServingsCount: UILabel!
    
    @IBOutlet weak var btnPostDish: UIButton!
    
    @IBOutlet weak var txtPricePerServing: UITextField!
    
    @IBOutlet var allDiets: [UIButton]!
    @IBOutlet var allTextFields: [UITextField]!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var txtDealDuration: UITextField!
    @IBOutlet var pickerDealDuration: UIDatePicker!
    
    @IBOutlet weak var viewUploadVideo: UIView!
    @IBOutlet weak var lblUploadVideo: UILabel!
    @IBOutlet weak var viewVideo: UIView!
    @IBOutlet weak var btnUploadVideo: UIButton!
    @IBOutlet weak var viewShootVideo: UIView!
    @IBOutlet weak var lblShootVideo: UILabel!
    @IBOutlet weak var btnShootVideo: UIButton!
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        GoCookVidupUploadConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for txt in self.allTextFields {
            txt.layer.cornerRadius = 5.0
            txt.clipsToBounds = true
            txt.add(padding: 10, viewMode: .leftSide)
        }
        
        self.pickerPreparationTime.countDownDuration = 0.0
        self.pickerDealDuration.countDownDuration = 0.0
        
        self.btnMinus.imageView?.contentMode = . scaleAspectFit
        self.btnPlus.imageView?.contentMode = . scaleAspectFit
        
        self.btnPostDish.layer.cornerRadius = 22.0
        self.btnPostDish.clipsToBounds = true
        
        self.txtPreparationTime.inputView = self.pickerPreparationTime
        self.txtPreparationTime.delegate = self
        
        self.txtDealDuration.inputView = self.pickerDealDuration
        self.txtDealDuration.delegate = self
        
        self.viewUploadVideo.layer.cornerRadius = 5.0
        self.viewUploadVideo.clipsToBounds = true
        self.viewShootVideo.clipsToBounds = true
        self.viewShootVideo.layer.cornerRadius = 5.0
        
        self.btnShootVideo.imageView?.contentMode = .scaleAspectFit
        self.btnUploadVideo.imageView?.contentMode = .scaleAspectFit
        
        self.cuisinesAdapter.prepareCuisineCollectionView(self.cuisineCollectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.btnPostDish.applyGradient(colors: [gradientStartColor, gradientEndColor], direction: .leftToRight)
    }
    
//    class func addToParentViewController(_ parentVC: GoCookViewController, completion : @escaping GoCookCompletion) -> GoCookVidupUploadViewController? {
//        let story = UIStoryboard.init(name: "GoCook", bundle: nil)
//        if let vidupsVC = parentVC.vidupsVC {
//            vidupsVC.addToParent(parentVC)
//            vidupsVC.completion = completion
//            return vidupsVC
//        } else if let vidupsVC = story.instantiateViewController(withIdentifier: "GoCookVidupUploadViewController") as? GoCookVidupUploadViewController {
//            vidupsVC.addToParent(parentVC)
//            vidupsVC.completion = completion
//            return vidupsVC
//        } else {
//            print("Critical Error")
//        }
//        return nil
//        
//    }
    
    private func addToParent(_ parentVC: GoCookViewController) {
        parentVC.addChildViewController(self)
        parentVC.viewStep2.addSubview(self.view)

        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.leftAnchor.constraint(equalTo: parentVC.viewStep2.leftAnchor).isActive = true
        self.view.rightAnchor.constraint(equalTo: parentVC.viewStep2.rightAnchor).isActive = true
        self.view.topAnchor.constraint(equalTo: parentVC.viewStep2.topAnchor).isActive = true
        self.view.bottomAnchor.constraint(equalTo: parentVC.viewStep2.bottomAnchor).isActive = true
        
        parentVC.view.layoutIfNeeded()
        self.view.layoutIfNeeded()
    }
    
    
    // MARK: - Event handling
    @IBAction func onDietTap(_ sender: UIButton) {
        for diet  in self.allDiets {
            diet.isSelected = (sender == diet)
        }
        //        sender.isSelected = true
    }
    
    @IBAction func onMinusTap(_ sender: UIButton) {
        if self.numberOfServings > 0 {
            self.numberOfServings -= 1
            self.lblServingsCount.text = "\(self.numberOfServings)"
        }
    }
    
    @IBAction func onPlusTap(_ sender: UIButton) {
        self.numberOfServings += 1
        self.lblServingsCount.text = "\(self.numberOfServings)"
    }
    
    @IBAction func onPostDishTap(_ sender: UIButton) {
        self.completion?()
    }
    
    @IBAction func onPreparationTimeChange(_ sender: UIDatePicker) {
        self.setPreparationTime()
    }
    
    @IBAction func onUploadVideo(_ sender: UIButton) {
        self.selectedOption = .Upload
        self.mediaPicker = MediaPicker.pickVideo(on: self, completion: { (url, error) in
        print(url)
        })
    }
    
    @IBAction func onShootVideo(_ sender: UIButton) {
        self.selectedOption = .Shoot
        self.mediaPicker = MediaPicker.recordVideo(on: self, completion: { (url, error) in
            print(url)
        })
    }
    
    // MARK: - Display logic
    
    func setPreparationTime() {
        let (h, m) = self.secondsToHoursMinutes(Int(self.pickerPreparationTime.countDownDuration))
        self.txtPreparationTime.text = "\(h):\(m)"
    }
    
    func setDealDuration() {
        let (h, m) = self.secondsToHoursMinutes(Int(self.pickerPreparationTime.countDownDuration))
        self.txtDealDuration.text = "\(h):\(m)"
    }
    
    func secondsToHoursMinutes(_ seconds : Int) -> (Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60)
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
                }
            }
            
            if let lbl = subView as? UILabel {
                self.animate {
                    lbl.isHighlighted = false
                }
            }
        }
    }
}

extension GoCookVidupUploadViewController : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField : UITextField) {
        if textField == self.txtPreparationTime {
            self.setPreparationTime()
        } else if textField == self.txtDealDuration {
            self.setDealDuration()
        }
    }
}

