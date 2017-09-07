
import UIKit
import Stripe
import MBProgressHUD

enum ShippingOption {
    case pickup
    case delivery
}

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
    @IBOutlet weak var lblDeliveryCharge: UILabel!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet var conTopLblChooseDeliveryTypeToDeliveryAddress: NSLayoutConstraint!
    @IBOutlet var conTopLblChooseDeliveryTypeToPhoneNumber: NSLayoutConstraint!
    
    @IBOutlet var pickerPickupTime: UIDatePicker!
    @IBOutlet weak var imgViewDish: UIImageView!
    
    @IBOutlet weak var txtPickupTime: UITextField!
    @IBOutlet weak var lblDishName: UILabel!
    @IBOutlet weak var lblSlotsCount: UILabel!
    @IBOutlet weak var btnAddAnotherAddress: UIButton!
    @IBOutlet weak var btnPickup: UIButton!
    @IBOutlet weak var btnDelivery: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var activityIndicatorForDeliveryQuote: UIActivityIndicatorView!
    
    @IBOutlet weak var addCartTextField: STPPaymentCardTextField!
    @IBOutlet weak var viewAddCard: UIView!
    @IBOutlet weak var btnAddCard: UIButton!
    
    var shippingOption: ShippingOption?
    var deliveryMethod: MFDeliveryOption?
    
    var cards: [STPCard] = []
    var selectedCardIndex: IndexPath?
    
    var slotsToBePurchased : UInt = 0
    var dish : MFDish!
    
    
    var uberWorker: UberRushDeliveryWorker?
    var uberAccessToken: String?
    var uberQuoteId: String?
    
    var postmatesWorker: PostmatesWorker?
    var postmatesQuoteId: String?
    
    var deliveryCharge: Double = 0
    var dropoffTimeInMinutes: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "BackBtn"), style: .plain, target: self, action: #selector(backButtonTapped(_:)))
        self.navigationItem.leftBarButtonItem = backButton
        
        //        if self.dish == nil {
        //            self.navigationController?.popViewController(animated: true)
        //            return
        //        }
        //        self.dummyData()
        
        self.activityIndicatorForDeliveryQuote.stopAnimating()
        
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
        self.paymentCollectionView.register(UINib(nibName: "SavedCardClnCell", bundle: nil), forCellWithReuseIdentifier: "SavedCardClnCell")
        self.paymentCollectionView.register(UINib(nibName: "AddCardClnCell", bundle: nil), forCellWithReuseIdentifier: "AddCardClnCell")
        
        self.btnAddCard.layer.cornerRadius = 5.0
        self.btnAddCard.clipsToBounds = true
        self.btnAddCard.backgroundColor = .clear
        self.btnAddCard.applyGradient(colors: [gradientStartColor, gradientEndColor], direction: .leftToRight)
        
        self.txtPickupTime.inputView = self.pickerPickupTime
        self.txtPickupTime.delegate = self
        self.pickerPickupTime.maximumDate = Date.init().dateFor(.tomorrow)
        self.getSavedCards()
        //        self.updateUI()
        
        self.txtPhoneNumber.text = DatabaseGateway.sharedInstance.getLoggedInUser()?.phone.phone ?? ""
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateDeliveryCharge() {
        if self.deliveryMethod == nil {
            return
        }
        
        self.activityIndicatorForDeliveryQuote.startAnimating()
        
        guard let dropOffAddress = DatabaseGateway.sharedInstance.getLoggedInUser()?.addressDetails else {
            self.activityIndicatorForDeliveryQuote.stopAnimating()
            return
        }
        
        guard let currentUser = DatabaseGateway.sharedInstance.getLoggedInUser() else {
            self.activityIndicatorForDeliveryQuote.stopAnimating()
            return
        }
        
        _ = DatabaseGateway.sharedInstance.getUserWith(userID: self.dish.user.id, { (dishUser) in
            if let dishUser = dishUser {
                
                guard let pickupAddress = dishUser.addressDetails else {
                    self.activityIndicatorForDeliveryQuote.stopAnimating()
                    return
                }
                
                if self.deliveryMethod == MFDeliveryOption.uberEATS {
                    self.loadUberAccessToken({ (token) in
                        self.uberWorker = UberRushDeliveryWorker(pickup: pickupAddress, dropoff: dropOffAddress, chef: dishUser, purchasingUser: currentUser, order: [self.dish], accessToken: token)
                        self.uberWorker!.getDeliveryQuote(completion: { response in
                            self.uberQuoteId = response?["quote_id"] as? String ?? ""
                            self.dropoffTimeInMinutes = response?["dropoff_eta"] as? Int ?? 0
                            let fees: Double = response?["fee"] as? Double ?? 0
                            self.lblDeliveryCharge.text = "Delivery charges: $\(fees)\nDrop-off in \(self.dropoffTimeInMinutes) minutes"
                            self.deliveryCharge = fees
                            self.activityIndicatorForDeliveryQuote.stopAnimating()
                        })
                    })
                } else if self.deliveryMethod == MFDeliveryOption.postmates {
                    if self.postmatesWorker == nil {
                        self.postmatesWorker = PostmatesWorker()
                    }
                    self.postmatesWorker?.checkforDeliveryAndQuote(pickupAddress: pickupAddress, dropOffAddress: dropOffAddress, completion: { (status, quote, errorMessage) in
                        if let quote = quote {
                            self.postmatesQuoteId = quote.id
                            
                            self.dropoffTimeInMinutes = 0
                            if let dropoffETA = quote.dropoffETA {
                                let datecomponents: DateComponents = Calendar.current.dateComponents([Calendar.Component.hour, Calendar.Component.minute], from: Date(), to: dropoffETA)
                                self.dropoffTimeInMinutes = (datecomponents.hour ?? 0) * 60 + (datecomponents.minute ?? 0)
                            }
                            
                            let fees: Double = quote.fees
                            self.deliveryCharge = fees
                            DispatchQueue.main.async {
                                self.lblDeliveryCharge.text = "Delivery charges: $\(fees)\nDrop-off in \(self.dropoffTimeInMinutes) minutes"
                                self.activityIndicatorForDeliveryQuote.stopAnimating()
                            }
                        }
                    })
                }
            } else {
                self.activityIndicatorForDeliveryQuote.stopAnimating()
            }
        })
    }
    
    func loadUberAccessToken(_ completion: @escaping (String)->Void) {
        if self.uberAccessToken == nil {
            UberRushDeliveryWorker.getAuthorizationcode { (authCode) in
                if let authCode = authCode {
                    UberRushDeliveryWorker.getAccessToken(authorizationCode: authCode, completion: { (data) in
                        let accessToken: String? = data?["access_token"] as? String
                        print("Uber accessToken: \(accessToken ?? "N.A")")
                        self.uberAccessToken = accessToken
                        completion(self.uberAccessToken!)
                    })
                }
            }
        } else {
            completion(self.uberAccessToken!)
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowEditAddressVC" {
            if let addressVC = segue.destination as? EditAddressViewController {
                addressVC.address = DatabaseGateway.sharedInstance.getLoggedInUser()?.addressDetails
                addressVC.delegate = self
            }
        }
    }
    
    //    func dummyData() {
    //        _ = DatabaseGateway.sharedInstance.getDishWith(dishID: "-KqAIpk0MFsdCn1sVogc") { (dishFound) in
    //            if let dishFound = dishFound {
    //                DispatchQueue.main.async {
    //                    self.dish = dishFound
    //                    self.slotsToBePurchased = self.dish.availableSlots
    //                    self.updateUI()
    //                    self.getSavedCards()
    //                }
    //            }
    //        }
    //    }
    
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
    
    func showAddCardView(_ show : Bool) {
        UIView.animate(withDuration: 0.27) {
            if show {
                self.view.bringSubview(toFront: self.viewAddCard)
                self.viewAddCard.alpha = 1
                self.addCartTextField.becomeFirstResponder()
            } else {
                self.viewAddCard.alpha = 0
                self.view.sendSubview(toBack: self.viewAddCard)
                self.addCartTextField.resignFirstResponder()
            }
        }
    }
    
    func setPickupTime() {
        self.txtPickupTime.text = self.pickerPickupTime.date.toString(format: .custom("hh:mm aa"))
    }
    
    @IBAction func onAddCardTap(_ sender: UIButton) {
        self.showAddCardView(false)
        guard let cardNumber: String = self.addCartTextField.cardNumber else {
            return
        }
        
        guard let cvc = self.addCartTextField.cvc else {
            return
        }
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        StripeGateway.shared.addPaymentMethod(number: cardNumber,expMonth: self.addCartTextField.expirationMonth, expYear: self.addCartTextField.expirationYear, cvc: cvc) { (cardId, error) in
            DispatchQueue.main.async {
                self.addCartTextField.clear()
                hud.hide(animated: true)
                if let error = error {
                    self.showAlert(error.localizedDescription, message: "")
                } else {
                    self.showAlert("Success!", message: "Card saved.")
                    self.getSavedCards()
                }
            }
        }
    }
    
    @IBAction func pickupAddress(_ sender: Any) {
        
        self.shippingOption = ShippingOption.pickup
        
        NSLayoutConstraint.deactivate([self.conTopLblChooseDeliveryTypeToPhoneNumber])
        NSLayoutConstraint.activate([self.conTopLblChooseDeliveryTypeToDeliveryAddress])
        self.view.layoutIfNeeded()
        
        self.deliveryMethod = nil
        self.lblDeliveryCharge.isHidden = true
        self.pickButton.layer.borderColor =  #colorLiteral(red: 1, green: 0.4620534182, blue: 0.1706305146, alpha: 1).cgColor
        self.deliveryButton.layer.borderColor =  #colorLiteral(red: 0.4588235294, green: 0.5333333333, blue: 0.6196078431, alpha: 1).cgColor
        self.addressView.isHidden = false
        self.btnConfirm.isHidden = false
        self.deliveryText.text! = "Chefs Address"
        self.delveryaddTextField.text = self.dish.address
        self.choosedeliveryText.text! = "Pick up time"
        self.delveryaddTextField.layer.backgroundColor = UIColor.clear.cgColor
        self.delveryaddTextField.isEnabled = false
        self.txtPickupTime.isHidden = false
        self.uberButton.isHidden = true
        self.postmateButton.isHidden = true
        self.txtPhoneNumber.isHidden = true
        self.lblPhoneNumber.isHidden = true
    }
    
    @IBAction func deliveryAddress(_ sender: Any) {
        
        self.shippingOption = ShippingOption.delivery
        
        NSLayoutConstraint.deactivate([self.conTopLblChooseDeliveryTypeToDeliveryAddress])
        NSLayoutConstraint.activate([self.conTopLblChooseDeliveryTypeToPhoneNumber])
        self.view.layoutIfNeeded()
        
        self.lblPhoneNumber.isHidden = false
        self.txtPhoneNumber.isHidden = false
        self.lblDeliveryCharge.isHidden = false
        self.pickButton.layer.borderColor =  #colorLiteral(red: 0.4588235294, green: 0.5333333333, blue: 0.6196078431, alpha: 1).cgColor
        self.deliveryButton.layer.borderColor =  #colorLiteral(red: 1, green: 0.4620534182, blue: 0.1706305146, alpha: 1).cgColor
        self.txtPickupTime.isHidden = true
        self.uberButton.isHidden = false
        self.postmateButton.isHidden = false
        self.delveryaddTextField.text = DatabaseGateway.sharedInstance.getLoggedInUser()?.addressDetails?.description ?? ""
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
        self.deliveryMethod = MFDeliveryOption.uberEATS
        self.updateDeliveryCharge()
        self.uberButton.layer.borderColor =  #colorLiteral(red: 1, green: 0.4620534182, blue: 0.1706305146, alpha: 1).cgColor
        self.postmateButton.layer.borderColor =  #colorLiteral(red: 0.4588235294, green: 0.5333333333, blue: 0.6196078431, alpha: 1).cgColor
    }
    
    @IBAction func postButnActn(_ sender: Any) {
        self.deliveryMethod = MFDeliveryOption.postmates
        self.updateDeliveryCharge()
        self.postmateButton.layer.borderColor =  #colorLiteral(red: 1, green: 0.4620534182, blue: 0.1706305146, alpha: 1).cgColor
        self.uberButton.layer.borderColor =  #colorLiteral(red: 0.4588235294, green: 0.5333333333, blue: 0.6196078431, alpha: 1).cgColor
    }
    
    @IBAction func onAddAnotherAddress(_ sender: UIButton) {
        self.performSegue(withIdentifier: "segueShowEditAddressVC", sender: self)
    }
    
    @IBAction func onCancelTap(_ sender: UIButton) {
        self.showAddCardView(false)
    }
    
    @IBAction func onConfirmPurchaseTap(_ sender: UIButton) {
        guard self.txtPhoneNumber.text != nil else {
            self.showAlert("Error", message: "Please add your phone number confirming purchase.")
            return
        }
        
        if self.shippingOption == nil {
            self.showAlert("Error", message: "Please select shipping option. Pickup/Delivery")
            return
        }
        
        if self.shippingOption == ShippingOption.delivery {
            if self.deliveryMethod != MFDeliveryOption.postmates {
                if self.deliveryMethod != MFDeliveryOption.uberEATS {
                    self.showAlert("Error", message: "Please select a delivery provider. UberEATS/Postmates")
                    return
                }
            }
            
            if self.deliveryMethod == MFDeliveryOption.uberEATS && self.uberQuoteId == nil {
                self.showAlert("Error", message: "Please try selecting UberEATS again.")
                return
            }
            
            if self.deliveryMethod == MFDeliveryOption.postmates && self.postmatesQuoteId == nil {
                self.showAlert("Error", message: "Please try selecting Postmates again.")
                return
            }
        }
        
        if let selectedIndex = self.selectedCardIndex,
            let currentUser = DatabaseGateway.sharedInstance.getLoggedInUser() {
        
            let card = self.cards[selectedIndex.item]
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            
            let totalAmount = (self.dish.pricePerSlot * Double(self.slotsToBePurchased)) + self.deliveryCharge
            
            StripeGateway.shared.createCharge(amount: totalAmount, sourceId: card.cardId!, fromUserId: currentUser.id, toUserId: self.dish.user.id, dishId: self.dish.id, dishName: self.dish.name, purpose: PaymentPurpose.purchase, completion: { (chargeId, error) in
                DispatchQueue.main.async {
                    hud.hide(animated: true)
                    if let error = error {
                        self.showAlert("Error!", message: error.localizedDescription, actionTitle: "OK", actionStyle: .default, actionhandler: { (action) in
                            DispatchQueue.main.async {
                                self.navigationController?.popViewController(animated: true)
                            }
                        })
                    } else {
                        // Charge was successful. Create a order object here
                        
                        if self.deliveryMethod == MFDeliveryOption.uberEATS {
                            
                            self.uberWorker!.updatePurchasingUserPhoneNumber(self.txtPhoneNumber.text!)
                            
                            // Create uber delivery
                            self.uberWorker!.createDelivery(with: self.uberQuoteId!, completion: { deliveryId in
                                if let deliveryId = deliveryId {
                                    self.addOrderToFirebase(deliveryId: deliveryId, chargeId: chargeId)
                                } else {
                                    // Failed
                                }
                            })
                        } else if self.deliveryMethod == MFDeliveryOption.postmates {
                            self.createPostmatesDelivery({ (deliveryId) in
                                if let deliveryId = deliveryId {
                                    self.addOrderToFirebase(deliveryId: deliveryId, chargeId: chargeId)
                                }
                            })
                        } else {
                            // Pickup
                            self.addOrderToFirebase(deliveryId: nil, chargeId: chargeId)
                        }
                    }
                }
            })
        } else {
            self.showAlert("No Card Found!", message: "Please add credit card before confirming purchase.")
        }
    }
    
    func addOrderToFirebase(deliveryId: String?, chargeId: String) {
        
        guard let currentUser = DatabaseGateway.sharedInstance.getLoggedInUser() else {
            return
        }
        
        let paymentMethod: MFPaymentMethod = MFPaymentMethod.stripe
        
        let paymentDetails: MFPaymentDetails = MFPaymentDetails()
        paymentDetails.id = chargeId
        paymentDetails.deliveryCharge = self.deliveryCharge
        paymentDetails.totalCharge = (self.dish.pricePerSlot * Double(self.slotsToBePurchased)) + self.deliveryCharge
        
        let order: MFOrder = MFOrder()
        order.quantity = self.slotsToBePurchased
        order.boughtBy = currentUser
        order.dish = self.dish
        order.paymentDetails = paymentDetails
        order.paymentMethod = paymentMethod
        order.deliveryId = deliveryId
        
        if self.deliveryMethod != nil {
            order.shippingMethod = MFShippingMethod.delivery
        } else {
            order.shippingMethod = MFShippingMethod.pickup
        }
        
        order.createdAt = Date()
        
        guard let currentUserAddress = DatabaseGateway.sharedInstance.getLoggedInUser()?.addressDetails else {
            return
        }
        order.shippingAddress = currentUserAddress
        order.deliveryOption = self.deliveryMethod
        
        DatabaseGateway.sharedInstance.createOrder(order, completion: { (error) in
            print("order registered")
            self.orderCompletedMessage()
        })
    }
    
    func orderCompletedMessage() {
        self.showAlert("Done!", message: "", actionTitle: "OK", actionStyle: .default, actionhandler: { (action) in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        })
        
    }
    
    func createPostmatesDelivery(_ completion: @escaping ((_ deliveryId: String?)->Void)) {
        
        guard let dropOffAddress = DatabaseGateway.sharedInstance.getLoggedInUser()?.addressDetails else {
            return
        }
        guard let currentUser = DatabaseGateway.sharedInstance.getLoggedInUser() else {
            return
        }
        
        DatabaseGateway.sharedInstance.getUserWith(userID: self.dish.user.id, { (dishUser) in
            if let dishUser = dishUser {
                guard let pickupAddress = dishUser.addressDetails else {
                    return
                }
                
                guard let postmatesQuoteId = self.postmatesQuoteId else {
                    return
                }
                
                self.postmatesWorker?.createDelivery(pickupAddress: pickupAddress,
                                                     dropOffAddress: dropOffAddress,
                                                     delivery_quoteid: postmatesQuoteId,
                                                     itemDescription: self.dish.name,
                                                     pickUpPlaceName: dishUser.name,
                                                     pickUpPhone: dishUser.phone.phone,
                                                     dropOffPlaceName: currentUser.name,
                                                     dropOffPhone: self.txtPhoneNumber.text!,
                                                     completion: { (deliveryId, errorMessage) in
                                                        
                                                        completion(deliveryId)
                })
            }
        })
    }
    
    @IBAction func onPickupTimeChange(_ sender: UIDatePicker) {
        self.setPickupTime()
    }
}

extension PaymentViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.txtPickupTime {
            self.setPickupTime()
        }
    }
}

extension PaymentViewController: EditAddressDelegate {
    func editedAddress(address: MFUserAddress?) {
        self.delveryaddTextField.text = address?.description
        if let currentUser = DatabaseGateway.sharedInstance.getLoggedInUser(),
            let userAddress = address {
            currentUser.address = userAddress.description
            currentUser.phone.phone = userAddress.phone
            currentUser.phone.countryCode = "+1"
            currentUser.addressDetails = userAddress
            DatabaseGateway.sharedInstance.updateUserEntity(with: currentUser, { (errorString) in
                
            })
        }
    }
}

extension PaymentViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell: SavedCardClnCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedCardClnCell", for: indexPath) as! SavedCardClnCell
            cell.set(card: self.cards[indexPath.item])
            if let selected = self.selectedCardIndex {
                if selected == indexPath {
                    cell.viewContent.backgroundColor = #colorLiteral(red: 1, green: 0.4765078425, blue: 0.1705591381, alpha: 1)
                } else {
                    cell.viewContent.backgroundColor = #colorLiteral(red: 0.2217648923, green: 0.2565669715, blue: 0.2926280499, alpha: 1)
                }
            } else {
                cell.viewContent.backgroundColor = #colorLiteral(red: 0.2217648923, green: 0.2565669715, blue: 0.2926280499, alpha: 1)
            }
            return cell
        } else {
            let cell : AddCardClnCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddCardClnCell", for: indexPath) as! AddCardClnCell
            cell.viewGradientBack.layer.cornerRadius = 5.0
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let addCardcell = cell as? AddCardClnCell {
            addCardcell.viewGradientBack.addGradienBorder(colors: [gradientStartColor, gradientEndColor], direction: .leftToRight, borderWidth: 1.0, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.selectedCardIndex = indexPath
            collectionView.reloadData()
        } else {
            self.showAddCardView(true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }
        return self.cards.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = collectionView.frame.size
        size.width = size.width * 0.95
        size.height = size.height * 0.95
        
        return size
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
