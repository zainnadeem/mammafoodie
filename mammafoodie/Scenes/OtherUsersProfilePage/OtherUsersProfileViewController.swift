import UIKit
import FirebaseAuth

protocol OtherUsersProfileViewControllerInput {
    func openDishPageWith(dishID:String)
    func openFollowers(followers:Bool, userList:[MFUser])
    func openFavouriteDishes()
}

protocol OtherUsersProfileViewControllerOutput {
    
    func setUpDishCollectionView(_ collectionView:UICollectionView, _ profileType:ProfileType)
    //    func loadDishCollectionViewForIndex(_ index:SelectedIndexForProfile)
    func loadUserProfileData(userID:String)
    func toggleFollow(userID:String, shouldFollow:Bool)
    func deallocDatabaseObserver()
}

enum ProfileType{
    case ownProfile
    case othersProfile
}

class OtherUsersProfileViewController: UIViewController, OtherUsersProfileViewControllerInput {
    
    var output: OtherUsersProfileViewControllerOutput!
    var router: OtherUsersProfileRouter!
    var collectionViewAdapter: DishesCollectionViewAdapter!
    
    private var profileType: ProfileType = .ownProfile // .othersProfile
    
    @IBOutlet weak var btnBack: UIBarButtonItem!
//    @IBOutlet weak var btnSettings: UIBarButtonItem!
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
        
        if let userid = self.userID {
            if userid == DatabaseGateway.sharedInstance.getLoggedInUser()?.id {
                self.profileType = .ownProfile
            } else {
                self.profileType = .othersProfile
            }
        } else {
            self.profileType = .ownProfile
        }
        if self.profileType == .ownProfile {
            if let user = DatabaseGateway.sharedInstance.getLoggedInUser() {
                self.userID = user.id
            } else {
                self.navigationController?.dismiss(animated: true, completion: {
                    
                })
            }
            let settingsBtn = UIBarButtonItem.init(image: #imageLiteral(resourceName: "Settings"), style: .plain, target: self, action: #selector(onSettingsTap(_:)))
            self.navigationItem.rightBarButtonItem = settingsBtn
        }
        
        self.output.setUpDishCollectionView(self.collectionView, self.profileType)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadProfile()
        self.collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.output.deallocDatabaseObserver()
    }
    
    //MARK: - Input
    func loadProfile() {
        if let user = self.userID {
            self.output.loadUserProfileData(userID: user)
        } else {
            self.navigationController?.dismiss(animated: true, completion: {
            })
        }
    }
    
    func openDishPageWith(dishID:String) {
        
        //Initiate segue and pass it to router in prepare for segue
        let dishVC = UIStoryboard(name:"DishDetail",bundle:nil).instantiateViewController(withIdentifier: "DishDetailViewController") as! DishDetailViewController
        dishVC.dishID = dishID
        self.present(dishVC, animated: true, completion: nil)
        
    }
    
    func openFavouriteDishes() {
        let favouriteNav = UIStoryboard(name: "Siri", bundle: nil).instantiateViewController(withIdentifier: "FavouriteDishNav") as! UINavigationController
        
        let vc = favouriteNav.viewControllers.first as! FavouriteDishesList
        vc.userID = self.userID!
        
        self.present(favouriteNav, animated: true, completion: nil)
    }
    
    func openFollowers(followers:Bool, userList:[MFUser]) {
        
        let followerNav = UIStoryboard(name: "Siri", bundle: nil).instantiateViewController(withIdentifier: "FollowerNav") as!
        UINavigationController
        
        let vc = followerNav.viewControllers.first as! FollowersListViewController
        
        //        let vc = UIStoryboard(name: "Siri", bundle: nil).instantiateViewController(withIdentifier: "FollowersListViewController") as! FollowersListViewController
        
        if followers {
            //show list of followers
            vc.followers = true
            
        } else {
            //show list of following
            vc.followers = false
        }
        //        vc.userList = userList
        
        vc.userID = self.userID!
        self.present(followerNav, animated: true, completion: nil)
        
    }
    
    // MARK: - Event handling
    
    func onSettingsTap(_ sender : UIBarButtonItem) {
        self.performSegue(withIdentifier: "segueShowSettingsViewController", sender: self)
    }
    
    @IBAction func chatButtonClicked(_ sender: UIButton) {
        
        let chatnav = UIStoryboard(name: "Siri", bundle: nil).instantiateViewController(withIdentifier: "ChatListNav") as! UINavigationController
        
        let chatList = chatnav.viewControllers.first as! ChatListViewController
        chatList.currentUser = AppDelegate.shared().currentUser!
        
        self.present(chatnav, animated: true, completion: nil)
        
        //To create a new conversation, assing the createChatWithUser property of chatVC with a user with who to create a new chat
        /*
         let worker = OtherUsersProfileWorker()
         worker.getUserDataWith(userID: "MW27Zsj1DSSKkP07NAK9VqqRz4I3") { (user) in
         chatList.createChatWithUser = user
         self.present(chatnav, animated: true, completion: nil)
         }
         */
        
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
            self.performSegue(withIdentifier: "segueGoCook", sender: nil)
            break
            
        default:
            break
        }
        
    }
    
    @IBAction func onBackTap(_ sender: UIBarButtonItem) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func openDishDetails(_ dish: MFDish) {
        if dish.user.id == DatabaseGateway.sharedInstance.getLoggedInUser()?.id {
            dish.accessMode = .owner
        } else {
            dish.accessMode = .viewer
        }
        if dish.mediaType == .liveVideo &&
            dish.endTimestamp == nil {
            self.performSegue(withIdentifier: "segueShowLiveVideoDetails", sender: dish)
        } else if dish.mediaType == .vidup || dish.mediaType == .picture {
            self.performSegue(withIdentifier: "segueShowDealDetails", sender: dish)
        }
    }
    
    // MARK: - Display logic
    
}
