
import UIKit
import Stripe
import MBProgressHUD

class PaymentViewController: UIViewController {
    
    @IBOutlet weak var paymentCollectionView: UICollectionView!
    @IBOutlet weak var pickButton: UIButton!
    @IBOutlet weak var deliveryButton: UIButton!
    @IBOutlet weak var postmateButton: UIButton!
    @IBOutlet weak var uberButton: UIButton!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var deliveryText: UILabel!
    @IBOutlet weak var choosedeliveryText: UILabel!
    @IBOutlet weak var delveryaddTextField: UITextField!
    @IBOutlet weak var pickTime: UILabel!
    @IBOutlet weak var imgViewDish: UIImageView!
    
    @IBOutlet weak var btnSaveCardTick: UIButton!
    @IBOutlet weak var lblDishName: UILabel!
    @IBOutlet weak var lblSlotsCount: UILabel!
    @IBOutlet weak var btnAddAnotherAddress: UIButton!
    @IBOutlet weak var btnPickup: UIButton!
    @IBOutlet weak var btnDelivery: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    
    var cards: [STPCard] = []
    var slotsToBePurchased : UInt = 0
    var dish : MFDish!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.dish == nil {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        self.paymentCollectionView.delegate = self
        self.paymentCollectionView.dataSource = self
        
        self.pickButton.layer.cornerRadius = self.pickButton.frame.height/2
        self.pickButton.layer.borderColor =   #colorLiteral(red: 0.4588235294, green: 0.5333333333, blue: 0.6196078431, alpha: 1).cgColor
        
        self.pickButton.layer.borderWidth = 1
        self.deliveryButton.layer.cornerRadius = self.deliveryButton.frame.height/2
        self.deliveryButton.layer.borderColor =   #colorLiteral(red: 0.4588235294, green: 0.5333333333, blue: 0.6196078431, alpha: 1).cgColor
        
        self.deliveryButton.layer.borderWidth = 1
        self.btnConfirm.layer.cornerRadius = self.btnConfirm.frame.height/2
        
        self.postmateButton.layer.cornerRadius = self.postmateButton.frame.height/2
        self.postmateButton.layer.borderColor =  #colorLiteral(red: 0.4588235294, green: 0.5333333333, blue: 0.6196078431, alpha: 1).cgColor
        self.postmateButton.layer.borderWidth = 1
        
        self.uberButton.layer.cornerRadius = self.uberButton.frame.height/2
        self.uberButton.layer.borderColor =  #colorLiteral(red: 0.4588235294, green: 0.5333333333, blue: 0.6196078431, alpha: 1).cgColor
        self.uberButton.layer.borderWidth = 1
        
        self.addressView.isHidden = true
        self.btnConfirm.isHidden = true
        self.paymentCollectionView.register(UINib.init(nibName: "SavedCardClnCell", bundle: nil), forCellWithReuseIdentifier: "SavedCardClnCell")
        self.paymentCollectionView.register(UINib.init(nibName: "AddCardClnCell", bundle: nil), forCellWithReuseIdentifier: "AddCardClnCell")
        self.getSavedCards()
        self.updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.tintColor = .darkGray
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUI() {
        self.imgViewDish.sd_setImage(with: self.dish.generateCoverThumbImageURL())
        self.lblDishName.text = self.dish.name
        self.lblSlotsCount.text = "\(self.slotsToBePurchased)"
        
    }
    
    func getSavedCards() {
        if let currentUser = DatabaseGateway.sharedInstance.getLoggedInUser() {
            StripeGateway.shared.getPaymentSources(for: currentUser.id, completion: { cards in
                self.cards = cards
                self.paymentCollectionView.reloadData()
            })
        }
    }
    
    @IBAction func pickupAddress(_ sender: Any) {
        
        self.pickButton.layer.borderColor =  #colorLiteral(red: 1, green: 0.4620534182, blue: 0.1706305146, alpha: 1).cgColor
        self.deliveryButton.layer.borderColor =  #colorLiteral(red: 0.4588235294, green: 0.5333333333, blue: 0.6196078431, alpha: 1).cgColor
        self.addressView.isHidden = false
        self.btnConfirm.isHidden = false
        self.deliveryText.text! = "Chefs Address"
        self.choosedeliveryText.text! = "Pick up time"
        self.delveryaddTextField.layer.backgroundColor = UIColor.clear.cgColor
        self.delveryaddTextField.isUserInteractionEnabled = false
        self.pickTime.isHidden = false
        self.uberButton.isHidden = true
        self.postmateButton.isHidden = true
    }
    
    @IBAction func deliveryAddress(_ sender: Any) {
        
        self.pickButton.layer.borderColor =  #colorLiteral(red: 0.4588235294, green: 0.5333333333, blue: 0.6196078431, alpha: 1).cgColor
        
        self.deliveryButton.layer.borderColor =  #colorLiteral(red: 1, green: 0.4620534182, blue: 0.1706305146, alpha: 1).cgColor
        
        self.pickTime.isHidden = true
        self.uberButton.isHidden = false
        self.postmateButton.isHidden = false
        
        self.addressView.isHidden = false
        self.btnConfirm.isHidden = false
        self.deliveryText.text! = "Delivery Address"
        self.choosedeliveryText.text! = "Choose Delivery Address"
        self.delveryaddTextField.isUserInteractionEnabled = true
        self.delveryaddTextField.layer.cornerRadius = 5
        self.delveryaddTextField.layer.borderColor = UIColor.clear.cgColor
        self.delveryaddTextField.layer.backgroundColor = #colorLiteral(red: 0.9782952666, green: 0.9755677581, blue: 0.9876046777, alpha: 1).cgColor
        
    }
    
    @IBAction func uberButnActn(_ sender: Any) {
        self.uberButton.layer.borderColor =  #colorLiteral(red: 1, green: 0.4620534182, blue: 0.1706305146, alpha: 1).cgColor
        self.postmateButton.layer.borderColor =  #colorLiteral(red: 0.4588235294, green: 0.5333333333, blue: 0.6196078431, alpha: 1).cgColor
    }
    
    @IBAction func postButnActn(_ sender: Any) {
        self.postmateButton.layer.borderColor =  #colorLiteral(red: 1, green: 0.4620534182, blue: 0.1706305146, alpha: 1).cgColor
        self.uberButton.layer.borderColor =  #colorLiteral(red: 0.4588235294, green: 0.5333333333, blue: 0.6196078431, alpha: 1).cgColor
    }
    
    @IBAction func onSaveCard(_ sender: UIButton) {
        
    }
    
    @IBAction func onAddAnotherAddress(_ sender: UIButton) {
        
    }
}

extension PaymentViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell: SavedCardClnCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedCardClnCell", for: indexPath) as! SavedCardClnCell
            cell.set(card: self.cards[indexPath.item])
            return cell
        } else {
            let cell : AddCardClnCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddCardClnCell", for: indexPath) as! AddCardClnCell
            cell.addGradienBorder(colors: [gradientStartColor, gradientEndColor])
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let card: STPCard = self.cards[indexPath.item]
        } else {
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }
        return self.cards.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.width
        return CGSize(width: width, height: width * 0.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
