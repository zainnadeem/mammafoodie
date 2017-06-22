import UIKit

protocol GoCookStep2ViewControllerInput {
    
}

protocol GoCookStep2ViewControllerOutput {
    
}

class GoCookStep2ViewController: UIViewController, GoCookStep2ViewControllerInput {
    
    var output: GoCookStep2ViewControllerOutput!
    var router: GoCookStep2Router!
    
    var cuisinesAdapter : CuisineCollectionViewAdapter = CuisineCollectionViewAdapter()
    var numberOfServings : UInt = 0
    
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
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        GoCookStep2Configurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Event handling
    
    // MARK: - Display logic
    
}
