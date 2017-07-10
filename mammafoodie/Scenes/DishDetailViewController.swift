import UIKit

protocol DishDetailViewControllerInput {
    func displayDish(_ response: DishDetail.Dish.Response)
    func displayLikeStatus(_ response: DishDetail.Like.Response)
    func displayFavoriteStatus(_ response: DishDetail.Favorite.Response)
    
}

protocol DishDetailViewControllerOutput {
    func getDish(with id: String)
    
    func likeButtonTapped(userId: String, dishId: String, selected: Bool)
    func checkLikeStatus(userId: String, dishId: String)
    
    func checkFavoritesStatus(userId: String, dishId: String)
    func favoriteButtonTapped(userId: String, dishId: String, selected: Bool)
    
}

class DishDetailViewController: UIViewController, DishDetailViewControllerInput, HUDRenderer {

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
    
    @IBOutlet weak var btnAddToFavorites: UIButton!
    
    @IBOutlet weak var lblDistanceAway: UILabel!
    @IBOutlet weak var lblNumberOfTimesOrdered: UILabel!
    @IBOutlet weak var lblPrepTime: UILabel!
    @IBOutlet weak var lblDishDescription: UILabel!
    @IBOutlet weak var lv_contentView: UIView!
    
    @IBOutlet weak var btnRequest: UIButton!
    
    
    @IBOutlet weak var lblCurrentlyCooking: UILabel!
    
    @IBOutlet weak var lblLeftDishesCount: UILabel!
    
    
    //if only dish ID is passed
    var dishID: String?
    
    //if dish object is passed 
    var dishForView: DishDetail.Dish.Response?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DishDetailConfigurator.sharedInstance.configure(viewController: self)
        
    }
    
    
    //TODO: - Need to be changed
    let coordinate0 = CLLocation(latitude: 12.97991, longitude: 77.72482)
    let coordinate1 = CLLocation(latitude: 12.8421, longitude: 77.6631)
    
   
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.output.getDish(with: "-Ko7jcz0kX1Kb1OValuf")
        
        lblCurrentlyCooking.layer.cornerRadius = 8
        lblCurrentlyCooking.clipsToBounds = true
        lblLeftDishesCount.layer.cornerRadius = 8
        lblLeftDishesCount.clipsToBounds = true
        
        self.showActivityIndicator()
        
        }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    // MARK: - Event handling
    func displayDish(_ response: DishDetail.Dish.Response) {
        
        self.hideActivityIndicator()
        guard let data = response.dish else { return }
        
        self.dishForView = response
        
        self.lblDishName.text = data.name
        self.lblUsername.text = data.user.name
        self.lblDishType.text = data.dishType.rawValue
        self.lblNumberOfComments.text = "\(Int(data.commentsCount))"
        self.lblNumberOfLikes.text = "\(Int(data.likesCount))"
        self.lblNumberOfTimesOrdered.text = String(describing: data.boughtOrders.count)
        self.lblPrepTime.text = "\(Int(data.preparationTime! / 60)) mins"
        self.lblDishDescription.text = data.description
        self.lblNumberOfTimesOrdered.text = "\(data.boughtOrders.count) Orders"
//        self.lblDistanceAway.text = "\(String(format: "%.2f",(coordinate0.distance(from: coordinate1))/1000)) Kms"
    
        
        self.lblLeftDishesCount.text = data.availableSlots.description + " Left"
        

        self.profileImageView.sd_setImage(with: DatabaseGateway.sharedInstance.getUserProfilePicturePath(for: data.user.id))
        
        
//        if let urlString = data.user.picture, let url = URL.init(string: urlString) {
//            self.profileImageView.sd_setImage(with: url)
//        }
        
        
        self.dishImageView.sd_setImage(with: data.generateCoverImageURL())
        
        //set profile imageview
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.shadowRadius = 3
        profileImageView.layer.shadowColor = UIColor.blue.cgColor
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.clipsToBounds = true
        
        
        //set button
        if let endTimeStamp = data.endTimestamp ,Date().timeIntervalSinceReferenceDate > endTimeStamp.timeIntervalSinceReferenceDate {
            self.btnRequest.setTitle("Request", for: .normal)
        } else {
            self.btnRequest.setTitle("Buy now", for: .normal)
        }
        
//        if Date.init() > data.endTimestamp! {
//            self.btnRequest.setTitle("Buy now", for: .normal)
//        } else {
//            self.btnRequest.setTitle("request", for: .normal)
//        }
        
        if let currentUser = (UIApplication.shared.delegate as! AppDelegate).currentUserFirebase{
            
            self.getDistanceBetweenUsers(userID1: currentUser.uid, userID2: data.user.id, { (distanceInKms) in
                 self.lblDistanceAway.text = distanceInKms
            })
            
            self.output.checkLikeStatus(userId: currentUser.uid, dishId: data.id)
            self.output.checkFavoritesStatus(userId: currentUser.uid , dishId: data.id)
        }
        
  
    }
    
    
    func displayFavoriteStatus(_ response: DishDetail.Favorite.Response) {
//        print(response.status)
        if response.status == true {
            self.btnAddToFavorites.isSelected = true
        }else{
            self.btnAddToFavorites.isSelected = false
        }
    }
    
    
    func displayLikeStatus(_ response: DishDetail.Like.Response){
//        print(response.status)
        if response.status == true {
            self.btnLikes.isSelected = true
        }else{
            self.btnLikes.isSelected = false
        }
    }

    func getDistanceAway(){
        
    }
    

    @IBAction func commentsBtnTapped(_ sender: Any) {
        //route to comments
//        let destinationVC = CommentsViewController()
   
//        if let response = self.dishForView {
//            destinationVC.dishID = response.dish?.id
//            self.present(destinationVC, animated: true, completion: nil)
//        }
 
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
        //like the dish
        if btnLikes.isSelected == false {
            btnLikes.isSelected = true
        }else{
            btnLikes.isSelected = false
        }
        
        if let dish = self.dishForView?.dish, let currentUser = (UIApplication.shared.delegate as! AppDelegate).currentUserFirebase{
            self.output.likeButtonTapped(userId: currentUser.uid, dishId: dish.id, selected: self.btnLikes.isSelected)
        }
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        //add to users favorites
        self.btnAddToFavorites.isSelected = !self.btnAddToFavorites.isSelected
        
        //FIXME: - call api to add/delete favourites
        
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
        
        if button.currentTitle! == "Request"{
            let vc = UIStoryboard(name: "Siri", bundle: nil).instantiateViewController(withIdentifier: "RequestDishViewController")
            self.present(vc, animated: true, completion: nil)
        }
        
        
        
    }
    
    
    func getDistanceBetweenUsers(userID1:String, userID2:String, _ completion : @escaping (String?) -> Void) {
        
        DatabaseGateway.sharedInstance.getUserWith(userID: userID1) { (user1) in
            
            
            DatabaseGateway.sharedInstance.getUserWith(userID: userID2, { (user2) in
                let latLong1 = user1?.addressLocation?.components(separatedBy: ",")
                let latLong2 = user2?.addressLocation?.components(separatedBy: ",")
                
                guard let lat1 = latLong1?.first, let lat2 = latLong2?.first, let long1 = latLong1?.last, let long2 = latLong2?.last  else {
                    completion(nil)
                    return
                }
                
               let cl1 = CLLocation(latitude: Double(lat1) ?? 0, longitude: Double(long1) ?? 0)
                
               let cl2 = CLLocation(latitude: Double(lat2) ?? 0, longitude: Double(long2) ?? 0)
                
               completion((cl1.distance(from: cl2)/1000).description)
                
            })
            
        }
    }
    
    
    
    // MARK: - Display logic
    
}
