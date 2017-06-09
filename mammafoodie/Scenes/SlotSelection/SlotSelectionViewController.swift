import UIKit

protocol SlotSelectionViewControllerInput {
    func selectedSlots(_ slots: Dictionary<String, Any>)
}

protocol SlotSelectionViewControllerOutput {
    
    func handleSlotSelection(_ sender:UIPanGestureRecognizer)
    func setUpCollectionView(_ collectionView:UICollectionView)
    
}

class SlotSelectionViewController: UIViewController, SlotSelectionViewControllerInput {
    
    var output: SlotSelectionViewControllerOutput!
    var router: SlotSelectionRouter!
    
    var selectedSlots : Dictionary<String, Any>?
    //MARK: - Outlets
    
    @IBOutlet weak var collectionView:UICollectionView!
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        SlotSelectionConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.view.addGestureRecognizer(pan)
        
        output.setUpCollectionView(self.collectionView)
    }
    
    // MARK: - Event handling
    
    func handlePan(_ sender:UIPanGestureRecognizer){
        
        output.handleSlotSelection(sender)
        
    }
    
    
    //MARK: - Input 
    
    func selectedSlots(_ slots: Dictionary<String, Any>){
        self.selectedSlots = slots
    }
    
    // MARK: - Display logic
    
}
