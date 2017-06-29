import UIKit

protocol GoCookStep2ViewControllerInput {
    
}

protocol GoCookStep2ViewControllerOutput {
    func setPreparationTime()
    func setDealDuration()
    func setupViewController()
    func selectDiet(_ diet : MFDishType)
    func selectMediaUploadType(_ type : GoCookMediaUploadType)
    func showOption(_ option : MFMediaType)
}

enum GoCookMediaUploadType {
    case VideoUpload, VideoShoot, PictureUpload, None
}

class GoCookStep2ViewController: UIViewController, GoCookStep2ViewControllerInput {
    
    var output: GoCookStep2ViewControllerOutput!
    var router: GoCookStep2Router!
    
    var selectedOption : MFMediaType = . unknown {
        didSet {
            self.output.showOption(self.selectedOption)
        }
    }
    
    var selectedDiet : MFDishType = .None {
        didSet {
            self.output.selectDiet(self.selectedDiet)
        }
    }
    
    var selectedImage : UIImage?
    var selectedVideoPath : URL?
    
    
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
        self.pickerDealDuration.countDownDuration = 0
        self.pickerPreparationTime.countDownDuration = 0
        self.output.setupViewController()
        self.cuisinesAdapter.prepareCuisineCollectionView(self.cuisineCollectionView)
    }
    
    // MARK: - Event handling
    
    @IBAction func onDietTap(_ sender: UIButton) {
        switch sender {
        case self.btnDietVegan:
            self.selectedDiet = .Vegan
            self.output.selectDiet(.Vegan)
            
        case self.btnDietVeg:
            self.selectedDiet = .Veg
            self.output.selectDiet(.Veg)
            
        case self.btnDietNonVeg:
            self.selectedDiet = .NonVeg
            self.output.selectDiet(.NonVeg)
            
        default:
            self.selectedDiet = .None
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
        if let dishName = self.txtTitle.text {
            if !dishName.isEmpty {
                if self.selectedDiet != .None {
                    if let cuisine = self.cuisinesAdapter.selectedCuisine {
                        if let _ = self.txtPreparationTime.text {
                            let preparationTime : Double = self.pickerPreparationTime.countDownDuration
                            if let totalSlots = UInt(self.lblServingsCount.text ?? "0") {
                                if let pricePerSlots = Double(self.txtPricePerServing.text ?? "0") {
                                    var ready = false
                                    var countDown : Double = -1
                                    switch self.selectedOption {
                                    case .liveVideo:
                                        ready = true
                                        
                                    case .vidup:
                                        if let _ = self.selectedVideoPath {
                                            ready = false
                                            self.showAlert("Required!", message: "Please select video.")
                                        } else {
                                            ready = true
                                        }
                                        
                                        if let _ = self.txtDealDuration.text {
                                            countDown = Double(self.pickerDealDuration.countDownDuration)
                                            if countDown == 0 {
                                                countDown = -1
                                            }
                                        }
                                        
                                    case .picture:
                                        if let _ = self.selectedVideoPath {
                                            ready = false
                                            self.showAlert("Required!", message: "Please select picture.")
                                        } else {
                                            ready = true
                                        }
                                        
                                    default:
                                        ready = false
                                    }
                                    if ready {
                                        let media = MFMedia.createNewMedia(with : self.selectedOption)
                                        let dish = MFDish.init(name: dishName, description: self.textViewDescription.text, cuisine: cuisine, preparationTime : preparationTime, totalSlots: totalSlots, withPrice: pricePerSlots, dishType : self.selectedDiet, media : media)
                                        let user = MFUser.init()
                                        user.id = FirebaseReference.user.generateAutoID()
                                        user.name = "Arjav"
//                                        dish.media.user = user
                                        dish.user = user
                                        media.dish = dish
                                        media.dealTime = countDown
                                        media.createdAt = Date.init()
                                        self.completion?(dish, self.selectedImage, self.selectedVideoPath)
                                    }
                                } else {
                                    self.showAlert("Required!", message: "Please enter price per servings.")
                                }
                            }
                        } else {
                            self.showAlert("Required!", message: "Please enter preparation.")
                        }
                    } else {
                        self.showAlert("Required!", message: "Please select cuisine.")
                    }
                } else {
                    self.showAlert("Required!", message: "Please enter dish diet.")
                }
            } else {
                self.showAlert("Required!", message: "Please enter dish name.")
            }
        } else {
            self.showAlert("Required!", message: "Please enter dish name.")
        }
    }
    
    @IBAction func onPreparationTimeChange(_ sender: UIDatePicker) {
        self.output.setPreparationTime()
    }
    
    @IBAction func onDealDurationChange(_ sender: UIDatePicker) {
        self.output.setDealDuration()
    }
    
    @IBAction func onCameraTap(_ sender: UIButton) {
        self.selectedMediaUploadType = .PictureUpload
        self.mediaPicker = MediaPicker.pickImage(on: self, completion: { (image, error) in
            if let img = image {
                self.selectedImage = img
            } else {
                self.showAlert("Error!", message: "Image Not Found")
            }
        })
    }
    
    @IBAction func onUploadVideo(_ sender: UIButton) {
        self.selectedMediaUploadType = .VideoUpload
        self.mediaPicker = MediaPicker.pickVideo(on: self, completion: { (urlString, error) in
            if let string = urlString {
                self.selectedVideoPath = URL.init(fileURLWithPath: string)
            } else {
                self.showAlert("Error!", message: "No Video found")
            }
        })
    }
    
    @IBAction func onShootVideo(_ sender: UIButton) {
        self.selectedMediaUploadType = .VideoShoot
        self.mediaPicker = MediaPicker.recordVideo(on: self, completion: { (urlString, error) in
            if let string = urlString {
                self.selectedVideoPath = URL.init(fileURLWithPath: string)
            } else {
                self.showAlert("Error!", message: "No Video found")
            }
        })
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

