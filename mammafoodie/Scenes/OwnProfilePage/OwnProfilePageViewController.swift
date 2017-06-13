import UIKit

protocol OwnProfilePageViewControllerInput {
     func openDishPageWith(dishID:Int)
}

protocol OwnProfilePageViewControllerOutput {
    func setUpDishCollectionView(_ collectionView:UICollectionView)
    func loadDishCollectionViewForIndex(_ index:Int)
}

class OwnProfilePageViewController: UIViewController, OwnProfilePageViewControllerInput {
    
    var output: OwnProfilePageViewControllerOutput!
    var router: OwnProfilePageRouter!
    
    
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
        OwnProfilePageConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.setUpDishCollectionView(self.collectionView)
        output.loadDishCollectionViewForIndex(0) //Loads first segment data by default
        
    }
    
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
