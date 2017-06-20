import UIKit

protocol GoCookLiveVideoUploadViewControllerInput {
    
}

protocol GoCookLiveVideoUploadViewControllerOutput {
    
}

class GoCookLiveVideoUploadViewController: UIViewController, GoCookLiveVideoUploadViewControllerInput {
    
    var output: GoCookLiveVideoUploadViewControllerOutput!
    var router: GoCookLiveVideoUploadRouter!
    
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
    
    
    @IBOutlet var allTextFields: [UITextField]!
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        GoCookLiveVideoUploadConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for txt in self.allTextFields {
            txt.layer.cornerRadius = 10.0
            txt.clipsToBounds = true
        }
        
        self.btnGoLive.layer.cornerRadius = 22.0
        self.btnGoLive.clipsToBounds = true
        
        self.txtPreparationTime.inputView = self.pickerPreparationTime
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.btnGoLive.applyGradient(colors: [gradientStartColor, gradientEndColor], direction: .leftToRight)
    }
    
    // MARK: - Event handling
    
    @IBAction func onMinusTap(_ sender: UIButton) {
        
    }
    
    @IBAction func onGoLiveTap(_ sender: UIButton) {
        
    }
    
    @IBAction func onPlusTap(_ sender: UIButton) {
        
    }
    
    @IBAction func onPreparationTimeChange(_ sender: UIDatePicker) {
        
    }
    // MARK: - Display logic
    
}
