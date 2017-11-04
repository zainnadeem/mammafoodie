import UIKit

protocol DishDetailViewControllerInput {
    func displayDish(_ response: DishDetail.Dish.Response)
    func displayLikeStatus(_ response: DishDetail.Like.Response)
    func displayFavouriteStatus(_ response: DishDetail.Favourite.Response)
    
}

protocol DishDetailViewControllerOutput {
    func getDish(with id: String)
    
    func likeButtonTapped(userId: String, dishId: String, selected: Bool)
    func checkLikeStatus(userId: String, dishId: String)
    
    func checkFavouritesStatus(userId: String, dishId: String)
    func favouriteButtonTapped(userId: String, dishId: String, selected: Bool)
    func stopObservingDish()
    func updateDishViewersCount(dishID:String, opened:Bool)
}

class DishDetailViewController: UIViewController, DishDetailViewControllerInput,HUDRenderer {
    
    var output: DishDetailViewControllerOutput!
    var router: DishDetailRouter!
    
    // MARK: - Object lifecycle
    
    @IBOutlet weak var dishImageView: UIImageView!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    
    @IBOutlet weak var lblDishType: UILabel!
    @IBOutlet weak var lblDishName: UILabel!
    @IBOutlet weak var btnComments: UIButton!
    @IBOutlet weak var lblNumberOfComments: UILabel!
    @IBOutlet weak var btnLikes: UIButton!
    @IBOutlet weak var lblNumberOfLikes: UILabel!
    @IBOutlet weak var btnAddToFavourites: UIButton!
    @IBOutlet weak var lblDistanceAway: UILabel!
    @IBOutlet weak var lblNumberOfTimesOrdered: UILabel!
    @IBOutlet weak var lblPrepTime: UILabel!
    @IBOutlet weak var lblDishDescription: UILabel!
    @IBOutlet weak var lv_contentView: UIView!
    @IBOutlet weak var btnRequest: UIButton!
    @IBOutlet weak var lblCurrentlyCooking: UILabel!
    @IBOutlet weak var lblLeftDishesCount: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var conHeightBtnRequest: NSLayoutConstraint!
    @IBOutlet weak var conBottomBtnRequest: NSLayoutConstraint!
    @IBOutlet weak var conTopBtnRequest: NSLayoutConstraint!
    
    
    //if only dish ID is passed
    var dishID: String?
    
    //if dish object is passed
    var dishForView: DishDetail.Dish.Response?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DishDetailConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let dishID = self.dishID {
            self.output.getDish(with: dishID)
            self.output.updateDishViewersCount(dishID:dishID,opened: true)
        }
        if let currentUser = (UIApplication.shared.delegate as! AppDelegate).currentUser{
            self.output.checkLikeStatus(userId: currentUser.id, dishId: dishID!)
            self.output.checkFavouritesStatus(userId: currentUser.id , dishId: dishID!)
        }
        self.lv_contentView.isHidden = true
        lblCurrentlyCooking.layer.cornerRadius = 8
        lblCurrentlyCooking.clipsToBounds = true
        lblLeftDishesCount.layer.cornerRadius = 8
        lblLeftDishesCount.clipsToBounds = true
        self.showActivityIndicator()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let currentUser = (UIApplication.shared.delegate as! AppDelegate).currentUser{
            self.output.checkLikeStatus(userId: currentUser.id, dishId: dishID!)
            self.output.checkFavouritesStatus(userId: currentUser.id , dishId: dishID!)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.dishID != nil {
            self.output.stopObservingDish()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let dishID = self.dishID{
            self.output.updateDishViewersCount(dishID:dishID,opened: false)
        }
    }
    
    // MARK: - Event handling
    func displayDish(_ response: DishDetail.Dish.Response) {
        
        self.hideActivityIndicator()
        
        guard let data = response.dish else { return }
        
        self.dishForView = response
        
        if let currentUser = DatabaseGateway.sharedInstance.getLoggedInUser() {
            if self.dishForView?.dish?.user.id == currentUser.id {
                self.conHeightBtnRequest.constant = 0
                self.conBottomBtnRequest.constant = 0
                self.conTopBtnRequest.constant = 0
            }
        }
        
        self.lblDishName.text = data.name
        self.lblUsername.text = data.user.name
        self.lblDishType.text = data.dishType.rawValue
        self.lblNumberOfComments.text = "\(UInt(data.commentsCount))"
        self.lblNumberOfLikes.text = "\(UInt(data.likesCount))"
        self.lblNumberOfTimesOrdered.text = "\(UInt(data.totalOrders)) Orders"
        self.lblPrepTime.text = "\(Int(data.preparationTime / 60)) mins"
        self.lblDishDescription.text = data.description
        //        self.lblDistanceAway.text = "\(String(format: "%.2f",(coordinate0.distance(from: coordinate1))/1000)) Kms"
        
        self.lblLeftDishesCount.text = data.availableSlots.description + " Left"
        
        //        self.lblDistanceAway.text = "\((coordinate0.distance(from: coordinate1))/1000) Kms"
        
        self.profileImageView.sd_setImage(with: DatabaseGateway.sharedInstance.getUserProfilePicturePath(for: data.user.id))
        
        if let url = data.coverPicURL {
            self.dishImageView.sd_setImage(with: url)
        } else if let url = data.mediaURL {
            self.dishImageView.sd_setImage(with: url)
        }
        
        //set profile imageview
        self.profileImageView.contentMode = .scaleAspectFill
        self.profileImageView.layer.shadowRadius = 3
        self.profileImageView.layer.shadowColor = UIColor.blue.cgColor
        self.profileImageView.layer.masksToBounds = false
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height / 2
        self.profileImageView.clipsToBounds = true
        
        //set button
        if let endTimeStamp = data.endTimestamp ,Date().timeIntervalSinceReferenceDate > endTimeStamp.timeIntervalSinceReferenceDate {
            self.btnRequest.setTitle("Request", for: .normal)
            self.lblCurrentlyCooking.isHidden = true
        } else {
            self.btnRequest.setTitle("Buy now", for: .normal)
            self.lblCurrentlyCooking.isHidden = false
        }
        
        
        if let currentUser = (UIApplication.shared.delegate as! AppDelegate).currentUser{
            self.getDistanceBetweenUsers(userID1: currentUser.id, userID2: data.user.id, { (distanceInKms) in
                if let distance = distanceInKms {
                    let s: String = self.displayString(from: distance)
                    self.lblDistanceAway.text = "\(s) KM"
                } else {
                    self.lblDistanceAway.text = "N.A"
                }
            })
            
        }
        
        if let currentUser: MFUser = DatabaseGateway.sharedInstance.getLoggedInUser() {
            self.output.checkLikeStatus(userId: currentUser.id, dishId: data.id)
            self.output.checkFavouritesStatus(userId: currentUser.id, dishId: data.id)
        }
        
        self.lv_contentView.isHidden = false
    }
    
    func displayString(from number: Double) -> String {
        var stringTemp: String = ""
        
        let amountFormatter = NumberFormatter()
        amountFormatter.locale = Locale.current
        amountFormatter.minimumFractionDigits = 0
        amountFormatter.maximumFractionDigits = 2
        
        var amountInString: String = "\(number)"
        let amountInNumber: NSNumber? = amountFormatter.number(from: amountInString)
        if amountInNumber != nil {
            let stringTemp: String? = amountFormatter.string(from: amountInNumber!)
            if stringTemp != nil {
                amountInString = stringTemp!
            }
        }
        stringTemp = stringTemp + amountInString
        
        let components = stringTemp.components(separatedBy: ".")
        if components.count > 1 {
            // Has decimal part
            if components[1].count == 1 {
                stringTemp = components.first!
                stringTemp.append(".")
                stringTemp.append(components[1].appending("0"))
            }
        }
        
        return stringTemp
    }
    
    func displayFavouriteStatus(_ response: DishDetail.Favourite.Response) {
        self.btnAddToFavourites.isSelected = response.status
    }
    
    func displayLikeStatus(_ response: DishDetail.Like.Response){
        self.btnLikes.isSelected = response.status
    }
    
    func getDistanceAway() {
        
    }
    
    @IBAction func commentsBtnTapped(_ sender: Any) {
        
        let commentsVC = UIStoryboard(name: "Siri", bundle: nil).instantiateViewController(withIdentifier: "CommentsViewController") as! CommentsViewController
        commentsVC.dish = self.dishForView?.dish
        
        if let currentUser = (UIApplication.shared.delegate as! AppDelegate).currentUser{
            commentsVC.user = currentUser
            
            self.present(commentsVC, animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        
        let activityController = UIActivityViewController(activityItems: ["Try \(self.dishForView!.dish!.name) on MammaFoodie"], applicationActivities: [])
        
        activityController.excludedActivityTypes = [
            .assignToContact,
            .saveToCameraRoll,
            .postToFlickr,
            .postToVimeo,
            .postToTencentWeibo,
            .postToTwitter,
            .postToFacebook,
            .openInIBooks
        ]
        
        present(activityController, animated: true, completion: nil)
        
    }
    
    @IBAction func likeBtnTapped(_ sender: Any) {
        var likesCount: Int = 0
        if let temp = self.dishForView?.dish?.likesCount {
            likesCount = Int(temp)
        }
        if btnLikes.isSelected == false {
            likesCount+=1
        } else {
            likesCount-=1
        }
        btnLikes.isSelected = !btnLikes.isSelected
        self.lblNumberOfLikes.text = "\(Int(likesCount))"
        
        if let dish = self.dishForView?.dish, let currentUser = (UIApplication.shared.delegate as! AppDelegate).currentUser {
            self.output.likeButtonTapped(userId: currentUser.id, dishId: dish.id, selected: self.btnLikes.isSelected)
        }
        
    }
    
    @IBAction func favouriteButtonTapped(_ sender: Any) {
        //add to users favourites
        
        self.btnAddToFavourites.isSelected = !self.btnAddToFavourites.isSelected
        
        if let dish = self.dishForView?.dish, let currentUser = (UIApplication.shared.delegate as! AppDelegate).currentUser {
            self.output.favouriteButtonTapped(userId: currentUser.id, dishId: dish.id, selected: self.btnAddToFavourites.isSelected)
        }
        
    }
    
    @IBAction func distanceAwayBtnTapped(_ sender: Any) {
        //open up mapview with pont
    }
    
    @IBAction func ordersButtonTapped(_ sender: Any) {
    }
    
    @IBAction func prepTimeTapped(_ sender: Any) {
        print("Preptime tapped")
    }
    
    @IBAction func requestBtnTapped(_ sender: Any) {
        //open up chat
        
        let button = sender as! UIButton
        
        if button.currentTitle == "Request"{
            
            guard let currentUser = DatabaseGateway.sharedInstance.getLoggedInUser() else {
                print("User not logged in DishDetailViewController")
                return
            }
            
            if self.dishForView?.dish?.user.id == currentUser.id {
                print("Can't request own dish.")
                return
            }
            
            let alertController: UIAlertController = UIAlertController(title: "Request dish", message: "Please enter desired quantity.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addTextField(configurationHandler: { (textField) in
                textField.keyboardType = UIKeyboardType.numberPad
            })
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "Request", style: UIAlertActionStyle.default, handler: { action in
                self.showActivityIndicator()
                let worker: RequestDishWorker = RequestDishWorker()
                let quantity: Int = Int(alertController.textFields?.first?.text ?? "0") ?? 0
                if let dish = self.dishForView?.dish {
                    if quantity > 0 {
                        self.createConversation({ (conversationId) in
                            self.sendDishRequestMessage(in: conversationId, quantity: quantity, dishName: dish.name, dish: dish)
                            
                            worker.requestDish(dish: dish, quantity: quantity, conversationId: conversationId, completion: { (success, errorMessage) in
                                self.hideActivityIndicator()
                                if let errorMessage = errorMessage {
                                    self.showAlert("Error", message: errorMessage)
                                } else {
                                    // self.showAlert("Success", message: "Dish requested to the Chef. Now you can contact the chef via chat.")
                                }
                            })
                        })
                    }
                } else {
                    self.showAlert(message: "Request failed. Please try again.")
                }
            }))
            self.present(alertController, animated: true, completion: {
                
            })
        } else { //Buy now -- Open slots page
            self.performSegue(withIdentifier: "seguePresentSlotSelectionViewController", sender: nil)
            //            let vc = UIStoryboard(name: "Siri", bundle: nil).instantiateViewController(withIdentifier: "SlotSelectionViewController")
            //
            //            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func createConversation(_ completion: @escaping ((_ conversationId: String)->Void)) {
        if let user2Id: String = self.dishForView?.dish?.user.id {
            _ = DatabaseGateway.sharedInstance.getUserWith(userID: user2Id, { (dishUser) in
                if let user1: MFUser = DatabaseGateway.sharedInstance.getLoggedInUser(),
                    let dishUser = dishUser {
                    DatabaseGateway.sharedInstance.createConversation(user1: user1, user2: dishUser, { (success, conversationId) in
                        if success {
                            if let conversationId = conversationId {
                                completion(conversationId)
                            } else {
                                self.showAlert(message: "Request failed. Please try again.")
                            }
                        } else {
                            self.showAlert(message: "Request failed. Please try again.")
                        }
                    })
                } else {
                    self.showAlert(message: "Request failed. Please try again.")
                }
            })
        } else {
            self.showAlert(message: "Request failed. Please try again.")
        }
    }
    
    func sendDishRequestMessage(in conversationId: String, quantity: Int, dishName: String, dish: MFDish) {
        _ = DatabaseGateway.sharedInstance.getUserWith(userID: dish.user.id) { (dishUser) in
            if let dishUser = dishUser {
                self.createMessage(quantity: quantity, dishName: dishName, dishUserName: dishUser.name, dishUserId: dishUser.id, conversationId: conversationId)
            } else {
                self.showAlert(message: "Request failed. Please try again.")
            }
        }
    }
    
    func createMessage(quantity: Int, dishName: String, dishUserName: String, dishUserId: String, conversationId: String) {
        let messageString: String = "Request for \(quantity) servings of \(dishName)"
        let senderDisplayName: String = dishUserName
        let senderId: String = dishUserId
        let message: MFMessage = MFMessage(with: senderDisplayName, messagetext: messageString, senderId: senderId)
        DatabaseGateway.sharedInstance.createMessage(with: message, conversationID: conversationId) { (success) in
            DispatchQueue.main.async {
                if success {
                    // Open chat view controller
                    self.openChatVC(conversationId: conversationId)
                } else {
                    self.showAlert(message: "Request failed. Please try again.")
                }
            }
        }
    }
    
    func openChatVC(conversationId: String) {
        DatabaseGateway.sharedInstance.getConversation(with: conversationId) { (conversationObject) in
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "segueShowConversationDetail", sender: conversationObject)
            }
        }
    }
    
    func purchase(slots : UInt) {
        self.performSegue(withIdentifier: "segueShowPaymentViewController", sender: slots)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        AppDelegate.close(vc: self)
    }
    
    func getDistanceBetweenUsers(userID1:String, userID2:String, _ completion : @escaping (Double?) -> Void) {
        _ = DatabaseGateway.sharedInstance.getUserWith(userID: userID1) { (user1) in
            let lat1: Double = Double(user1?.addressDetails?.latitude ?? "0") ?? 0
            let long1: Double = Double(user1?.addressDetails?.longitude ?? "0") ?? 0
            _ = DatabaseGateway.sharedInstance.getUserWith(userID: userID2, { (user2) in
                let lat2: Double = Double(user2?.addressDetails?.latitude ?? "0") ?? 0
                let long2: Double = Double(user2?.addressDetails?.longitude ?? "0") ?? 0
                //                guard let lat1 = latLong1?.first, let lat2 = latLong2?.first, let long1 = latLong1?.last, let long2 = latLong2?.last  else {
                //                    completion(nil)
                //                    return
                //                }
                let cl1 = CLLocation(latitude: Double(lat1), longitude: Double(long1))
                let cl2 = CLLocation(latitude: Double(lat2), longitude: Double(long2))
                completion(cl1.distance(from: cl2)/1000)
            })
        }
        
    }
    
    @IBAction func btnUsernameTapped(_ sender: UIButton) {
        if let userId = self.dishForView?.dish?.user.id {
            self.performSegue(withIdentifier: "segueShowUserProfile", sender: userId)
        }
    }
    // MARK: - Display logic
    
}
