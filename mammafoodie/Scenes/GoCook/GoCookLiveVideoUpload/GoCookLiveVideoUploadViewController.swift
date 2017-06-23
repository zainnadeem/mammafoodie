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
}

extension GoCookLiveVideoUploadViewController : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField : UITextField) {
        if textField == self.txtPreparationTime {
            self.setPreparationTime()
        }
    
    }
}
