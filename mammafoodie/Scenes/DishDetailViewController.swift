import UIKit

protocol DishDetailViewControllerInput {
    func displayDish(_ response: DishDetail.Response)
}

protocol DishDetailViewControllerOutput {
    func getDish(with id: String)

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
    
    @IBOutlet weak var txtViewDishDescription: UITextView!
    
    @IBOutlet weak var btnRequest: UIButton!
    
    //if only dish ID is passed
    var dishID: String?
    
    //if dish object is passed 
    var dish: DishDetail.Response?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DishDetailConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dishID = "-KnyGJpK7WjR9zjrlxZS"
        
        
        if let passedDish = dish {
            displayDish(passedDish)
        }else{
            if let id = dishID {
                self.output.getDish(with: id)
            } else {
                print("Set up AlertVC saying no dish found")
            }
        }
    }
    
    // MARK: - Event handling
    
    

    
    func displayDish(_ response: DishDetail.Response) {
        
        guard let data = response.dish else { return }
        
        self.lblDishName.text = data.name
        self.lblUsername.text = data.username
        self.lblDishType.text = data.type.rawValue
        self.lblNumberOfComments.text = String(describing: data.numberOfComments)
        self.lblNumberOfLikes.text = String(describing: data.numberOfLikes)
        self.lblNumberOfTimesOrdered.text = String(describing: data.boughtOrders.count)
        self.lblPrepTime.text = String(describing: data.preparationTime)
        self.txtViewDishDescription.text = data.description
        
    }

    func getDistanceAway(){
        
    }
    

    @IBAction func commentsBtnTapped(_ sender: Any) {
        //route to comments
        
    }
    
    @IBAction func likeBtnTapped(_ sender: Any) {
        //like the dish
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
    }
    
    @IBAction func requestBtnTapped(_ sender: Any) {
        //open up chat
    }
    
    
    
    
    
    
    // MARK: - Display logic
    
}
