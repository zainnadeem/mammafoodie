import UIKit

protocol OtherUsersProfileViewControllerInput {
    func openDishPageWith(dishID:Int)
}

protocol OtherUsersProfileViewControllerOutput {
    
    func setUpDishCollectionView(_ collectionView:UICollectionView)
    func loadDishCollectionViewForIndex(_ index:Int)
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
        
        output.setUpDishCollectionView(self.collectionView)
        output.loadDishCollectionViewForIndex(0) //Loads first segment data by default
        
    }
    
    //MARK: - Input
    
    func openDishPageWith(dishID:Int){
        
        //Initiate segue and pass it to router in prepare for segue
        
    }
    
    
    
    // MARK: - Event handling
    
    @IBAction func segmentedControlDidChangeSelection(sender:UISegmentedControl){
        
       let index = sender.selectedSegmentIndex
       output.loadDishCollectionViewForIndex(index)
        
    }
    
    
    
    // MARK: - Display logic
    
}
