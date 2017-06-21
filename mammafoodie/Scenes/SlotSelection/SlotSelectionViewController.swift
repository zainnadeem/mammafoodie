import UIKit

protocol SlotSelectionViewControllerInput {
    func selectedSlots(_ slots: Dictionary<String, Any>)
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
    
    @IBOutlet weak var usersBoughtCollectionView: UICollectionView!
    
    @IBOutlet weak var btnDone: UIButton!
    
    @IBOutlet weak var lblSlotsPickedCount: UILabel!
    
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
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        collectionView.reloadData()
                collectionViewAdapter.addCollectionViewGrid()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        collectionViewAdapter.addCollectionViewGrid()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        collectionView.reloadData()
//        collectionViewAdapter.addCollectionViewGrid()
    }
    
   
    
    // MARK: - Event handling
    
    func handlePan(_ sender:UIPanGestureRecognizer){
        output.handleSlotSelection(withPanGesture: sender, adapter: collectionViewAdapter)
    }
    
    @IBAction func dismiss(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Input 
    func selectedSlots(_ slots: Dictionary<String, Any>){
        
    }
    
    
    // MARK: - Display logic
    
}
