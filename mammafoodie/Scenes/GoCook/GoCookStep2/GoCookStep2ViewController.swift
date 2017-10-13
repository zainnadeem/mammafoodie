import UIKit
import AVFoundation
import AVKit

protocol GoCookStep2ViewControllerInput {
    
}

protocol GoCookStep2ViewControllerOutput {
    func setPreparationTime()
    func setDealDuration()
    func setupViewController()
    func selectDiet(_ diet : MFDishType)
    func selectMediaUploadType(_ type : GoCookMediaUploadType)
    func showOption(_ option : MFDishMediaType)
    func clearData()
}

enum GoCookMediaUploadType {
    case VideoUpload, VideoShoot, PictureUpload, None
}

class GoCookStep2ViewController: UIViewController, GoCookStep2ViewControllerInput, EditAddressDelegate {
    
    var output: GoCookStep2ViewControllerOutput!
    var router: GoCookStep2Router!
    
    var moviePlayer : AVPlayerViewController = AVPlayerViewController.init()
    
    var selectedOption : MFDishMediaType = . unknown {
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
    
    let locationWorker = CurrentLocationWorker()
    
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
    
    @IBOutlet weak var btnClosePicturePreview: UIButton!
    @IBOutlet weak var btnPicturePreview: UIButton!
    
    @IBOutlet weak var btnVideoUploadPreview: UIButton!
    @IBOutlet weak var btnCloseVideoUploadPreview: UIButton!
    
    @IBOutlet weak var btnVideoShootPreview: UIButton!
    @IBOutlet weak var btnCloseVideoShootPreview: UIButton!
    
    @IBOutlet var previewButtons: [UIButton]!
    @IBOutlet var previewCloseButtons: [UIButton]!
    
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
                    if let cuisine = self.getSelectedCuisine() {
                        if let textPreparationTime = self.txtPreparationTime.text {
                            if !textPreparationTime.isEmpty {
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
                                                ready = true
                                            } else {
                                                ready = false
                                                self.showAlert("Required!", message: "Please select video.")
                                            }
                                            
                                            if let _ = self.txtDealDuration.text {
                                                countDown = Double(self.pickerDealDuration.countDownDuration)
                                                if countDown == 0 {
                                                    countDown = -1
                                                }
                                            }
                                            
                                        case .picture:
                                            if let _ = self.selectedImage {
                                                ready = true
                                            } else {
                                                ready = false
                                                self.showAlert("Required!", message: "Please select picture.")
                                            }
                                            
                                        default:
                                            ready = false
                                        }
                                        if ready {
                                            self.locationWorker.getCurrentLocation({ (location, error) in
                                                if let currentLocation = location {
                                                    if let user = DatabaseGateway.sharedInstance.getLoggedInUser() {
                                                        let dish = MFDish(name: dishName, description: self.textViewDescription.text, cuisine: cuisine, dishType: self.selectedDiet, mediaType: self.selectedOption)
                                                        dish.preparationTime = preparationTime
                                                        dish.availableSlots = totalSlots
                                                        dish.totalSlots = totalSlots
                                                        dish.pricePerSlot = pricePerSlots
                                                        dish.user = user
                                                        dish.createTimestamp = Date.init()
                                                        dish.location = currentLocation.coordinate
                                                        if dish.mediaType == .vidup  {
                                                            dish.endTimestamp = dish.createTimestamp.addingTimeInterval(countDown)
                                                        } else if dish.mediaType == .picture {
                                                            dish.endTimestamp = dish.createTimestamp.addingTimeInterval(60 * 60 * 24)
                                                        }
                                                        
                                                        if let address = user.addressDetails {
                                                            dish.address = address.description
                                                        } else {
                                                            let addressEditVC = UIStoryboard(name: "Siri", bundle: nil).instantiateViewController(withIdentifier: "EditAddressViewController") as! EditAddressViewController
                                                            addressEditVC.address = nil
                                                            addressEditVC.delegate = self
                                                            self.navigationController?.pushViewController(addressEditVC, animated: true)
                                                        }
                                                        
                                                        DispatchQueue.main.async {
                                                            self.completion?(dish, self.selectedImage, self.selectedVideoPath)
                                                        }
                                                    } else {
                                                        self.showAlert("User not Found", message: "")
                                                    }
                                                } else {
                                                    print("Location not Found")
                                                    //                                                    self.showAlert("Location not Found", message: "Please make sure location service is enabled.")
                                                }
                                            })
                                        }
                                    } else {
                                        self.showAlert("Required!", message: "Please enter price per servings.")
                                    }
                                }
                            } else {
                                self.showAlert("Required!", message: "Please enter preparation.")
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
            DispatchQueue.main.async {
                if let img = image {
                    self.selectedImage = img
                    self.showPreview(image : img)
                } else if let _ = error {
                    self.showAlert("Error!", message: "Image Not Found")
                } else {
                    //Cancelled
                    self.clearPreviews()
                }
            }
        })
    }
    
    @IBAction func onUploadVideo(_ sender: UIButton) {
        self.selectedMediaUploadType = .VideoUpload
        self.mediaPicker = MediaPicker.pickVideo(on: self, completion: { (urlString, error) in
            if let videoURL = urlString {
                self.selectedVideoPath = videoURL
                self.showPreview(video: videoURL, for: .VideoUpload)
            } else if let _ = error {
                self.showAlert("Error!", message: "No Video Found")
            } else {
                //Cancelled
                self.clearPreviews()
            }
        })
    }
    
    @IBAction func onShootVideo(_ sender: UIButton) {
        self.selectedMediaUploadType = .VideoShoot
        self.mediaPicker = MediaPicker.recordVideo(on: self, completion: { (urlString, error) in
            if let videoURL = urlString {
                self.selectedVideoPath = videoURL
                self.showPreview(video: videoURL, for: .VideoShoot)
            } else if let _ = error {
                self.showAlert("Error!", message: "No Video Found")
            } else {
                //Cancelled
                self.clearPreviews()
            }
            
        })
    }
    
    @IBAction func onPicturePreview(_ sender: UIButton) {
        if let originalImage = self.selectedImage {
            ImageEditorVC.presentEditor(with: originalImage, on: self, completion: { (editedImage) in
                if let eImage = editedImage {
                    self.selectedImage = eImage
                    self.showPreview(image: eImage)
                }
            })
        }
    }
    
    @IBAction func onClosePicturePreview(_ sender: UIButton) {
        self.selectedImage = nil
        self.btnPicturePreview.isHidden = true
        self.btnClosePicturePreview.isHidden = true
        self.btnPicturePreview.setImage(nil, for: .normal)
        self.selectedMediaUploadType = .None
    }
    
    @IBAction func onVideoShoorPreview(_ sender: UIButton) {
        if let videoPath = self.selectedVideoPath {
            self.moviePlayer.player = AVPlayer.init(url: videoPath)
            self.moviePlayer.player?.play()
            self.moviePlayer.allowsPictureInPicturePlayback = false
            self.moviePlayer.showsPlaybackControls = true
            self.present(self.moviePlayer, animated: true, completion: {
                
            })
        }
    }
    
    @IBAction func onVideoUploadPreview(_ sender: UIButton) {
        self.onVideoShoorPreview(sender)
    }
    
    @IBAction func onCloseVideoShootPreview(_ sender: UIButton) {
        self.clearPreviews()
    }
    
    @IBAction func onCloseVideUploadPreview(_ sender: UIButton) {
        self.clearPreviews()
    }
    
    // MARK: - Display logic
    func clearData() {
        self.output.clearData()
        self.cuisinesAdapter.deselectAllCuisines()
        self.clearPreviews()
    }
    
    func showPreview(image: UIImage) {
        self.btnPicturePreview.isHidden = false
        self.btnClosePicturePreview.isHidden = false
        self.btnPicturePreview.setImage(image, for: .normal)
        self.viewPictureContainer.bringSubview(toFront: self.btnPicturePreview)
    }
    
    func showPreview(video: URL, for mode: GoCookMediaUploadType) {
        if let thumb = MediaPicker.createThumbnailOfVideoFromFileURL(video) {
            self.selectedImage = thumb
            switch mode {
            case .VideoShoot:
                self.btnVideoShootPreview.setImage(thumb, for: .normal)
                self.btnVideoShootPreview.isHidden = false
                self.btnCloseVideoShootPreview.isHidden = false
                self.btnCloseVideoUploadPreview.isHidden = true
                self.btnVideoUploadPreview.isHidden = true
                self.btnVideoUploadPreview.setImage(nil, for: .normal)
                
            default:
                self.btnVideoUploadPreview.setImage(thumb, for: .normal)
                self.btnCloseVideoUploadPreview.isHidden = false
                self.btnVideoUploadPreview.isHidden = false
                self.btnVideoShootPreview.isHidden = true
                self.btnCloseVideoShootPreview.isHidden = true
                self.btnVideoShootPreview.setImage(nil, for: .normal)
            }
        } else {
            self.clearPreviews()
        }
    }
    
    func editedAddress(address:MFUserAddress?) {
        if let address = address {
            self.user?.phone.phone = address.phone
            self.user?.phone.countryCode = "+1"
            self.user?.addressDetails = address
            DatabaseGateway.sharedInstance.updateUserEntity(with: self.user!, { (error) in
                for subview in self.addressStackView.subviews where subview.tag != -1 {
                    self.addressStackView.removeArrangedSubview(subview)
                    subview.removeFromSuperview()
                }
                self.getUserAddress()
            })
        }
    }
    
    func clearPreviews() {
        self.selectedImage = nil
        self.selectedMediaUploadType = .None
        self.selectedVideoPath = nil
        self.btnVideoUploadPreview.setImage(nil, for: .normal)
        self.btnVideoShootPreview.setImage(nil, for: .normal)
        self.btnVideoShootPreview.isHidden = true
        self.btnCloseVideoShootPreview.isHidden = true
        self.btnCloseVideoUploadPreview.isHidden = true
        self.btnVideoUploadPreview.isHidden = true
    }
    
    func getSelectedCuisine() -> MFCuisine? {
        for cuisine in  self.cuisinesAdapter.cuisines {
            if cuisine.isSelected {
                return cuisine
            }
        }
        
        return nil
    }
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

