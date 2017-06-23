import UIKit

protocol GoCookStep2ViewControllerInput {
    
}

protocol GoCookStep2ViewControllerOutput {
    func setPreparationTime()
    func setDealDuration()
    func setupViewController()
    func selectDiet(_ diet : GoCookDiet)
    func selectMediaUploadType(_ type : GoCookMediaUploadType)
    func showOption(_ option : GoCookOption)
}

enum GoCookMediaUploadType {
    case VideoUpload, VideoShoot, PictureUpload, None
}

enum GoCookDiet {
    case Veg, NonVeg, Vegan, None
}

class GoCookStep2ViewController: UIViewController, GoCookStep2ViewControllerInput {
    
    var output: GoCookStep2ViewControllerOutput!
    var router: GoCookStep2Router!
    
    var selectedOption : GoCookOption = . None {
        didSet {
            self.output.showOption(self.selectedOption)
        }
    }
    
    var selectedDiet : GoCookDiet = .None {
        didSet {
            self.output.selectDiet(self.selectedDiet)
        }
    }
    
    var selectedMediaUploadType : GoCookMediaUploadType = .None {
        didSet {
            self.output.selectMediaUploadType(self.selectedMediaUploadType)
        }
    }
    
    var cuisinesAdapter : CuisineCollectionViewAdapter = CuisineCollectionViewAdapter()
    var numberOfServings : UInt = 0
    var mediaPicker : MediaPicker?
    var completion : GoCookCompletion?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var btnDietVeg: UIButton!
    @IBOutlet weak var btnDietNonVeg: UIButton!
    @IBOutlet weak var btnDietVegan: UIButton!
    
    @IBOutlet weak var cuisineCollectionView: UICollectionView!
    
    @IBOutlet weak var viewPictureContainer: UIView!
    @IBOutlet weak var textViewDescription: UITextView!
    @IBOutlet weak var viewPictureUploadCameraContainer: UIView!
    @IBOutlet weak var viewPictureUploadCamera: UIView!
    @IBOutlet weak var btnCamera: UIButton!
    
    @IBOutlet weak var viewVideoContainer: UIView!
    @IBOutlet weak var viewVideoUploadCameraContainer: UIView!
    @IBOutlet weak var viewDealSurationContainer: UIView!
    @IBOutlet weak var viewVideoUploadContainer: UIView!
    @IBOutlet weak var btnVideoUpload: UIButton!
    @IBOutlet weak var lblVideoUpload: UILabel!
    
    @IBOutlet weak var viewVideoShootContainer: UIView!
    @IBOutlet weak var btnVideoShoot: UIButton!
    @IBOutlet weak var lblVideoShoot: UILabel!
    
    @IBOutlet weak var txtDealDuration: UITextField!
    @IBOutlet var pickerDealDuration: UIDatePicker!
    
    @IBOutlet weak var txtPreparationTime: UITextField!
    @IBOutlet var pickerPreparationTime: UIDatePicker!
    
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var lblServingsCount: UILabel!
    
    @IBOutlet weak var txtPricePerServing: UITextField!
    
    @IBOutlet var allDiets: [UIButton]!
    @IBOutlet var allTextFields: [UITextField]!
    
    @IBOutlet weak var btnPostDish: UIButton!
    
    
    @IBOutlet weak var conVerticalViewPictureContainer_lblPrepareTime: NSLayoutConstraint!
    @IBOutlet weak var conVerticalCuisineClnView_lblPrepareTime: NSLayoutConstraint!
    @IBOutlet weak var conVerticalViewVideoContainer_lblPreparationTime: NSLayoutConstraint!
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        GoCookStep2Configurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.output.setupViewController()
        self.cuisinesAdapter.prepareCuisineCollectionView(self.cuisineCollectionView)
    }
    
    // MARK: - Event handling
    
    @IBAction func onDietTap(_ sender: UIButton) {
        switch sender {
        case self.btnDietVegan:
            self.output.selectDiet(.Vegan)
            
        case self.btnDietVeg:
            self.output.selectDiet(.Veg)
            
        case self.btnDietNonVeg:
            self.output.selectDiet(.NonVeg)
            
        default:
            self.output.selectDiet(.None)
        }
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
        self.output.setPreparationTime()
    }
    
    @IBAction func onDealDurationChange(_ sender: UIDatePicker) {
        self.output.setDealDuration()
    }
    
    @IBAction func onCameraTap(_ sender: UIButton) {
        self.selectedMediaUploadType = .PictureUpload
//        self.mediaPicker = MediaPicker.pickImage(on: self, completion: { (image, error) in
//            print(image as Any)
//        })
    }
    
    @IBAction func onUploadVideo(_ sender: UIButton) {
        self.selectedMediaUploadType = .VideoUpload
//        self.mediaPicker = MediaPicker.pickVideo(on: self, completion: { (url, error) in
//            print(url as Any)
//        })
    }
    
    @IBAction func onShootVideo(_ sender: UIButton) {
        self.selectedMediaUploadType = .VideoShoot
//        self.mediaPicker = MediaPicker.recordVideo(on: self, completion: { (url, error) in
//            print(url as Any)
//        })
    }

    
    // MARK: - Display logic
    
}

extension GoCookStep2ViewController : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField : UITextField) {
        if textField == self.txtPreparationTime {
            self.output.setPreparationTime()
        } else if textField == self.txtDealDuration {
            self.output.setDealDuration()
        }
        
    }
}

