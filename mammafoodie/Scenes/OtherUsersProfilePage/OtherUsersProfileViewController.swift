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
}

enum ProfileType{
    case ownProfile
    case othersProfile
}


class OtherUsersProfileViewController: UIViewController, OtherUsersProfileViewControllerInput {
    
    var output: OtherUsersProfileViewControllerOutput!
    var router: OtherUsersProfileRouter!
    var collectionViewAdapter: DishesCollectionViewAdapter!
    
    var profileType:ProfileType = .ownProfile // .othersProfile
    
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
        
        self.output.setUpDishCollectionView(self.collectionView, self.profileType)
        if let user = Auth.auth().currentUser{
            self.userID = user.uid
            self.output.loadUserProfileData(userID: self.userID!)
        }
    }
    
    //MARK: - Input
    
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
    
    @IBAction func settingsButtonClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func closeButtonClicked(_ sender: UIButton) {
        
        
        
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
            break
            
        default:
            break
        }
        
    }
    
    @IBAction func btnDismissTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnLogoutTapped(_ sender: UIButton) {
        AppDelegate.shared().setLoginViewController()
        let worker = FirebaseLoginWorker()
        worker.signOut { (errorMessage) in
            
        }
    }
    
    
    // MARK: - Display logic
    
}
