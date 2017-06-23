import UIKit

protocol OtherUsersProfileViewControllerInput {
    func openDishPageWith(dishID:Int)
    func loadScreenWithData(_ profileData:[AnyHashable:Any])
}

protocol OtherUsersProfileViewControllerOutput {
    
    func setUpDishCollectionView(_ collectionView:UICollectionView)
    func loadDishCollectionViewForIndex(_ index:SelectedIndexForProfile)
}

enum ProfileType{
    case ownProfile
    case othersProfile
}


class OtherUsersProfileViewController: UIViewController, OtherUsersProfileViewControllerInput {
    
    var output: OtherUsersProfileViewControllerOutput!
    var router: OtherUsersProfileRouter!
    var collectionViewAdapter: DishesCollectionViewAdapter!
    
    var profileType:ProfileType = .ownProfile
    
    //MARK: - IBOutlets
    @IBOutlet weak var lblUserName:UILabel!
    
    @IBOutlet weak var lblProfileDescription:UILabel!
    
    @IBOutlet weak var lblDishesSold:UILabel!
    
    @IBOutlet weak var lblFollowers:UILabel!
    
    @IBOutlet weak var lblFollowing:UILabel!
    
    @IBOutlet weak var collectionView:UICollectionView!
    
    @IBOutlet weak var collectionViewHeightConstraint:NSLayoutConstraint!
    
    @IBOutlet weak var btnFollow: UIButton!
    
    
    @IBOutlet weak var cookedSegmentStackView: UIStackView!
    
    @IBOutlet weak var boughtSegmentStackView: UIStackView!
    
    
    @IBOutlet weak var activitySegmentStackView: UIStackView!
    
    
    @IBOutlet weak var menuSelectionHairlineView: UIView!
    
    
    @IBOutlet weak var lblCookedCount: UILabel!
    
    @IBOutlet weak var lblBoughtCount: UILabel!
    
    
    @IBOutlet weak var lblActivityCount: UILabel!
    
    
    @IBOutlet weak var hairLineViewXConstraint: NSLayoutConstraint?
    
    
    @IBOutlet weak var lblLikedDishesCount: UILabel!
    
    
    @IBOutlet weak var lblCookedDishesCount: UILabel!
    
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    
    @IBOutlet weak var lblCookedMenuHeader: UILabel!
    
    @IBOutlet weak var lblBoughtMenuHeader: UILabel!
    
    @IBOutlet weak var lblActivityMenuHeader: UILabel!
    
    @IBOutlet weak var btnSettings: UIButton!
    
    
    var selectedIndexForProfile : SelectedIndexForProfile = .cooked
    
    let unSelectedMenuTextColor = UIColor(red: 83/255, green: 85/255, blue: 87/255, alpha: 1)
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        OtherUsersProfileConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.setUpDishCollectionView(self.collectionView)
        output.loadDishCollectionViewForIndex(.cooked) //Loads first segment data by default
        
        let tapCooked = UITapGestureRecognizer(target: self, action: #selector(self.segmentedControlDidChangeSelection(sender:)))
        
        let tapBought = UITapGestureRecognizer(target: self, action: #selector(self.segmentedControlDidChangeSelection(sender:)))
        
        let tapActivity = UITapGestureRecognizer(target: self, action: #selector(self.segmentedControlDidChangeSelection(sender:)))
        
        cookedSegmentStackView.restorationIdentifier = "cooked"
        boughtSegmentStackView.restorationIdentifier = "bought"
        activitySegmentStackView.restorationIdentifier = "activity"
        
        cookedSegmentStackView.addGestureRecognizer(tapCooked)
        boughtSegmentStackView.addGestureRecognizer(tapBought)
        activitySegmentStackView.addGestureRecognizer(tapActivity)
        
        btnFollow.layer.cornerRadius = btnFollow.frame.size.height/2
        btnFollow.clipsToBounds = true
        
        menuSelectionHairlineView.layer.cornerRadius = menuSelectionHairlineView.frame.size.height/2
        menuSelectionHairlineView.clipsToBounds = true
        
        profilePicImageView.layer.cornerRadius = 5
        profilePicImageView.clipsToBounds  = true
        
        let color1 = UIColor(red: 1, green: 0.55, blue: 0.17, alpha: 1)
        let color2 = UIColor(red: 1, green: 0.39, blue: 0.13, alpha: 1)
        
        if profileType == .othersProfile{
            btnFollow.applyGradient(colors: [color1, color2], direction: .leftToRight)
            btnSettings.isHidden = true
        } else {
            //Own profile
            let greenColor = UIColor(red: 0, green: 0.74, blue: 0.22, alpha: 1)
            btnFollow.backgroundColor = greenColor
            btnFollow.setTitle("Go Cook", for: .normal)
            btnSettings.isHidden = false
        }
        
        
        menuSelectionHairlineView.applyGradient(colors: [color1, color2], direction: .leftToRight)
        
        
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.collectionViewHeightConstraint.constant = collectionView.contentSize.height
        updateHairLineMenuPosition()
    }
    
    
    //MARK: - Input
    
    func openDishPageWith(dishID:Int){
        
        //Initiate segue and pass it to router in prepare for segue
        
    }
    
    func loadScreenWithData(_ profileData:[AnyHashable:Any]){
        
        //Adding dummy data
        
        let profile = DummyData.sharedInstance.profileUser!
        
        self.lblUserName.text = profile.name
        self.lblFollowers.text = profile.followers.keys.count.description
        self.lblFollowing.text = profile.following.keys.count.description
        self.lblProfileDescription.text = profile.profileDescription
        self.lblDishesSold.text = profile.dishesSoldCount.description
        self.lblCookedDishesCount.text = profile.cookedDishes.keys.count.description
        self.lblCookedCount.text = profile.cookedDishes.keys.count.description
        self.lblLikedDishesCount.text = profile.likedDishes.keys.count.description
        self.profilePicImageView.image = UIImage(named: profile.picture!)!
        
    }
    
    
    // MARK: - Event handling
    
    @IBAction func segmentedControlDidChangeSelection(sender:UITapGestureRecognizer){
        
        let senderView = sender.view!.restorationIdentifier!
        
        switch senderView {
            
        case "cooked":
            
            self.selectedIndexForProfile = .cooked
            output.loadDishCollectionViewForIndex(.cooked)
            
        case "bought":
            
            self.selectedIndexForProfile = .bought
            output.loadDishCollectionViewForIndex(.bought)
            
        case "activity":
            
            self.selectedIndexForProfile = .activity
            output.loadDishCollectionViewForIndex(.activity)
            
        default:
            return
        }
        
        self.collectionViewHeightConstraint.constant = collectionView.contentSize.height
//        self.view.layoutIfNeeded()
        
        
        self.updateHairLineMenuPosition()
        
        UIView.animate(withDuration: 0.27, animations: {
            self.view.layoutIfNeeded()
            self.view.setNeedsUpdateConstraints()
        })
        
    }
    
    
    @IBAction func settingsButtonClicked(_ sender: UIButton) {
        
        
    }
    
    
    @IBAction func closeButtonClicked(_ sender: UIButton) {
        
        
    }
    
    
    @IBAction func followButtonClicked(_ sender: UIButton) {
        
        
        
    }
    
    // MARK: - Display logic
    
    func updateHairLineMenuPosition(){
        
        self.lblBoughtMenuHeader.textColor = unSelectedMenuTextColor
        self.lblCookedMenuHeader.textColor = unSelectedMenuTextColor
        self.lblActivityMenuHeader.textColor = unSelectedMenuTextColor
        
        switch self.selectedIndexForProfile {
        case .cooked:
            
            self.hairLineViewXConstraint?.constant = self.cookedSegmentStackView.center.x - 3
            self.lblCookedMenuHeader.textColor = .black
            
            
        case .bought:
  
            self.hairLineViewXConstraint?.constant = self.boughtSegmentStackView.center.x - 3
            self.lblBoughtMenuHeader.textColor = .black
            
        case .activity:
            
            self.hairLineViewXConstraint?.constant = self.activitySegmentStackView.center.x - 3
            self.lblActivityMenuHeader.textColor = .black
            
        }
    }
    
    @IBAction func btnDismissTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
