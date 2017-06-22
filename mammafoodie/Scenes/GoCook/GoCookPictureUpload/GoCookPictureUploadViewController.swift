import UIKit

protocol GoCookPictureUploadViewControllerInput {
    
}

protocol GoCookPictureUploadViewControllerOutput {
    
}

class GoCookPictureUploadViewController: UIViewController, GoCookPictureUploadViewControllerInput {
    
    var output: GoCookPictureUploadViewControllerOutput!
    var router: GoCookPictureUploadRouter!
    
    var cuisinesAdapter : CuisineCollectionViewAdapter = CuisineCollectionViewAdapter()
    var numberOfServings : UInt = 0
    
    var completion : GoCookCompletion?
    
    var mediaPicker : MediaPicker?
    
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
    
    @IBOutlet weak var viewCamera: UIView!
    @IBOutlet weak var btnCamera: UIButton!
    
    @IBOutlet weak var txtViewDescription: UITextView!
    
    // MARK: - Object lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        GoCookPictureUploadConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for txt in self.allTextFields {
            txt.layer.cornerRadius = 5.0
            txt.clipsToBounds = true
            txt.add(padding: 10, viewMode: .leftSide)
        }
        
        self.txtViewDescription.layer.cornerRadius = 5.0
        self.txtViewDescription.clipsToBounds = true
        
        self.viewCamera.layer.cornerRadius = 5.0
        self.viewCamera.clipsToBounds = true
        
        self.pickerPreparationTime.countDownDuration = 0.0
        
        self.btnMinus.imageView?.contentMode = . scaleAspectFit
        self.btnPlus.imageView?.contentMode = . scaleAspectFit
        
        self.btnPostDish.layer.cornerRadius = 22.0
        self.btnPostDish.clipsToBounds = true
        
        self.txtPreparationTime.inputView = self.pickerPreparationTime
        self.txtPreparationTime.delegate = self
        
        self.cuisinesAdapter.prepareCuisineCollectionView(self.cuisineCollectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.btnPostDish.applyGradient(colors: [gradientStartColor, gradientEndColor], direction: .leftToRight)
    }
    
//    class func addToParentViewController(_ parentVC: GoCookViewController, completion : @escaping GoCookCompletion) -> GoCookPictureUploadViewController? {
//        let story = UIStoryboard.init(name: "GoCook", bundle: nil)
//        if let pictureVC = parentVC.pictureVC {
//            pictureVC.completion = completion
//            pictureVC.addToParent(parentVC)
//            return pictureVC
//        } else if let pictureVC = story.instantiateViewController(withIdentifier: "GoCookPictureUploadViewController") as? GoCookPictureUploadViewController{
//            pictureVC.completion = completion
//            pictureVC.addToParent(parentVC)
//            return pictureVC
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
    
    @IBAction func onCameraTap(_ sender: UIButton) {
        if sender.isSelected {
            self.deselectView(self.viewCamera)
        } else {
            self.selectView(self.viewCamera)
        }
        
        
        self.mediaPicker = MediaPicker.pickImage(on: self, completion: { (image, error) in
            print(image)
        })
    }
    
    @IBAction func onPostDishTap(_ sender: UIButton) {
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
    
    func animate(_ animation :@escaping () -> Void) {
        UIView.animate(withDuration: 0.27, delay: 0, options: .curveEaseInOut, animations: animation) { (finished) in
            
        }
    }
}

extension GoCookPictureUploadViewController : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField : UITextField) {
        self.setPreparationTime()
    }
}
