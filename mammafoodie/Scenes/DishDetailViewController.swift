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

class DishDetailViewController: UIViewController, DishDetailViewControllerInput {
    
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
        
        
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    // MARK: - Event handling
    func displayDish(_ response: DishDetail.Dish.Response) {
        
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
        self.lblDistanceAway.text = "\(String(format: "%.2f",(coordinate0.distance(from: coordinate1))/1000)) Kms"
        
        
        //        self.lblDistanceAway.text = "\((coordinate0.distance(from: coordinate1))/1000) Kms"
        self.profileImageView.sd_setImage(with: DatabaseGateway.sharedInstance.getUserProfilePicturePath(for: data.user.id))
        
        
        self.dishImageView.sd_setImage(with: data.mediaURL)
        
        //set profile imageview
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.shadowRadius = 3
        profileImageView.layer.shadowColor = UIColor.blue.cgColor
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.clipsToBounds = true
        
        
        //set button
        if Date.timeIntervalSinceReferenceDate > data.endTimestamp?.timeIntervalSinceReferenceDate ?? 0 {
            self.btnRequest.setTitle("Buy now", for: .normal)
        } else {
            self.btnRequest.setTitle("request", for: .normal)
        }
        
        
        self.output.checkLikeStatus(userId: data.user.id, dishId: data.id)
        self.output.checkFavoritesStatus(userId: data.user.id, dishId: data.id)
        
    }
    
    
    func displayFavoriteStatus(_ response: DishDetail.Favorite.Response) {
        
    }
    
    
    func displayLikeStatus(_ response: DishDetail.Like.Response){
        if response.status == true {
            self.btnLikes.isSelected = false
        }else{
            self.btnLikes.isSelected = true
        }
    }
    
    func getDistanceAway(){
        
    }
    
    
    @IBAction func commentsBtnTapped(_ sender: Any) {
        //route to comments
        //        let destinationVC = CommentsViewController()
        //
        //        if let response = self.dishForView {
        //            destinationVC.dishID = response.dish?.id
        //            self.present(destinationVC, animated: true, completion: nil)
        //        }
        
    }
    
    @IBAction func likeBtnTapped(_ sender: Any) {
        //like the dish
        if btnLikes.isSelected == false {
            btnLikes.isSelected = true
        }else{
            btnLikes.isSelected = false
        }
        
        if let dish = self.dishForView?.dish{
            self.output.likeButtonTapped(userId: dish.user.id, dishId: dish.id, selected: self.btnLikes.isSelected)
        }
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        //add to users favorites
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
    }
    
    
    
    
    
    
    // MARK: - Display logic
    
}
