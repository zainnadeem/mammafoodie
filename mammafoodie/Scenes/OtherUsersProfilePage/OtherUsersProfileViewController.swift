import UIKit
import FirebaseAuth

protocol OtherUsersProfileViewControllerInput {
    func openDishPageWith(dishID:Int)
}

protocol OtherUsersProfileViewControllerOutput {
    
    func setUpDishCollectionView(_ collectionView:UICollectionView, _ profileType:ProfileType)
//    func loadDishCollectionViewForIndex(_ index:SelectedIndexForProfile)
    func loadUserProfileData(userID:String)
    func toggleFollow(userID:String, shouldFollow:Bool)
}

enum ProfileType{
    case ownProfile
    case othersProfile
}


class OtherUsersProfileViewController: UIViewController, OtherUsersProfileViewControllerInput {
    
    var output: OtherUsersProfileViewControllerOutput!
    var router: OtherUsersProfileRouter!
    var collectionViewAdapter: DishesCollectionViewAdapter!
    
    var profileType:ProfileType = .othersProfile

    @IBOutlet weak var collectionView:UICollectionView!
    
    
    var selectedIndexForProfile : SelectedIndexForProfile = .cooked
    
    let unSelectedMenuTextColor = UIColor(red: 83/255, green: 85/255, blue: 87/255, alpha: 1)
    
    var userID:String?
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        OtherUsersProfileConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.setUpDishCollectionView(self.collectionView, self.profileType)
        
        if let user = Auth.auth().currentUser{
            
            self.userID = user.uid
            
            output.loadUserProfileData(userID: self.userID!)
        }
        
    }

    
    //MARK: - Input
    
    func openDishPageWith(dishID:Int){
        
        //Initiate segue and pass it to router in prepare for segue
        
    }
    
    
    // MARK: - Event handling
    
    
    @IBAction func settingsButtonClicked(_ sender: UIButton) {
        
        
        
    }
    
    
    @IBAction func closeButtonClicked(_ sender: UIButton) {
        
        
        
    }
    
    
    @IBAction func followButtonClicked(_ sender: UIButton) {
        
        switch sender.currentTitle!.lowercased(){
            case "follow":
                sender.setTitle("UnFollow", for: .normal)
                output.toggleFollow(userID: self.userID!, shouldFollow: true)
                
                
            break
            
            case "unfollow":
                sender.setTitle("Follow", for: .normal)
                output.toggleFollow(userID: self.userID!, shouldFollow: false)
            break
            
            case "go cook":
            break
            
        default:
            break
        }
        
    }
    
    // MARK: - Display logic
    
    @IBAction func btnDismissTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
