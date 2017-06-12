import UIKit

protocol OtherUsersProfileViewControllerInput {
    
}

protocol OtherUsersProfileViewControllerOutput {
    
}

class OtherUsersProfileViewController: UIViewController, OtherUsersProfileViewControllerInput {
    
    var output: OtherUsersProfileViewControllerOutput!
    var router: OtherUsersProfileRouter!
    var collectionViewAdapter: DishesCollectionViewAdapter!
    
    //MARK: - IBOutlets
    @IBOutlet weak var lblUserName:UILabel!
    
    @IBOutlet weak var lblProfileDescription:UILabel!
    
    @IBOutlet weak var lblDishesSold:UILabel!
    
    @IBOutlet weak var lblFollowers:UILabel!
    
    @IBOutlet weak var lblFollowing:UILabel!
    
    @IBOutlet weak var collectionView:UICollectionView!
    
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        OtherUsersProfileConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewAdapter = DishesCollectionViewAdapter()
        collectionViewAdapter.collectionView = self.collectionView
    }
    
    // MARK: - Event handling
    
    // MARK: - Display logic
    
}
