import UIKit

protocol GoCookLiveVideoUploadViewControllerInput {
    
}

protocol GoCookLiveVideoUploadViewControllerOutput {
    
}

class GoCookLiveVideoUploadViewController: UIViewController, GoCookLiveVideoUploadViewControllerInput {
    
    var output: GoCookLiveVideoUploadViewControllerOutput!
    var router: GoCookLiveVideoUploadRouter!
    
    var cuisinesAdapter : CuisineCollectionViewAdapter = CuisineCollectionViewAdapter()
    var numberOfServings : UInt = 0
    
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
    
    @IBOutlet weak var btnGoLive: UIButton!
    
    @IBOutlet weak var txtPricePerServing: UITextField!
    
    @IBOutlet var allDiets: [UIButton]!
    @IBOutlet var allTextFields: [UITextField]!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewContainer: UIView!
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        GoCookLiveVideoUploadConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for txt in self.allTextFields {
            txt.layer.cornerRadius = 5.0
            txt.clipsToBounds = true
            txt.add(padding: 10, viewMode: .leftSide)
        }
        self.btnMinus.imageView?.contentMode = . scaleAspectFit
        self.btnPlus.imageView?.contentMode = . scaleAspectFit
        
        self.pickerPreparationTime.countDownDuration = 0.0
        
        self.btnGoLive.layer.cornerRadius = 22.0
        self.btnGoLive.clipsToBounds = true
        
        self.txtPreparationTime.inputView = self.pickerPreparationTime
        self.txtPreparationTime.delegate = self
        
        self.cuisinesAdapter.prepareCuisineCollectionView(self.cuisineCollectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.btnGoLive.applyGradient(colors: [gradientStartColor, gradientEndColor], direction: .leftToRight)
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
    
    
    @IBAction func onGoLiveTap(_ sender: UIButton) {
        self.completion?()
    }
    
    @IBAction func onPreparationTimeChange(_ sender: UIDatePicker) {
        self.setPreparationTime()
    }
    
    // MARK: - Display logic
    
    func setPreparationTime() {
        let (h, m) = self.secondsToHoursMinutes(Int(self.pickerPreparationTime.countDownDuration))
        self.txtPreparationTime.text = "\(h):\(m)"
    }
    
    func secondsToHoursMinutes(_ seconds : Int) -> (Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60)
    }
    
//    class func addToParentViewController(_ parentVC: GoCookViewController, completion : @escaping GoCookCompletion) -> GoCookLiveVideoUploadViewController? {
//        let story = UIStoryboard.init(name: "GoCook", bundle: nil)
//        if let liveVideoVC = parentVC.liveVideoVC {
//            liveVideoVC.addToParent(parentVC)
//            liveVideoVC.completion = completion
//            return liveVideoVC
//        } else if let liveVideoVC = story.instantiateViewController(withIdentifier: "GoCookLiveVideoUploadViewController") as? GoCookLiveVideoUploadViewController{
//            liveVideoVC.addToParent(parentVC)
//            liveVideoVC.completion = completion
//            return liveVideoVC
//        } else {
//            print("Critical Error")
//        }
//        return nil
//        
//    }
//    
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
}

extension GoCookLiveVideoUploadViewController : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField : UITextField) {
        if textField == self.txtPreparationTime {
            self.setPreparationTime()
        }
    
    }
}
