import UIKit

protocol SlotSelectionViewControllerInput {
    
}

protocol SlotSelectionViewControllerOutput {
    
    func handleSlotSelection(withPanGesture sender:UIPanGestureRecognizer, adapter:SlotCollectionViewAdapter)
}

class SlotSelectionViewController: UIViewController, SlotSelectionViewControllerInput {
    
    var output: SlotSelectionViewControllerOutput!
    var router: SlotSelectionRouter!
    
    var collectionViewAdapter : SlotCollectionViewAdapter!
    
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
        
        collectionViewAdapter = SlotCollectionViewAdapter()
        collectionViewAdapter.collectionView = self.collectionView
        
//       let selectedCells = collectionViewAdapter.selectedCells
        
    }
    
    // MARK: - Event handling
    
    func handlePan(_ sender:UIPanGestureRecognizer){
        output.handleSlotSelection(withPanGesture: sender, adapter: collectionViewAdapter)
    }
    
    
    //MARK: - Input 
    
    
    
    // MARK: - Display logic
    
}
