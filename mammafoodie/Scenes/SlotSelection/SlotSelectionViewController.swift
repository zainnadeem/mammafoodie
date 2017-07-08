import UIKit

protocol SlotSelectionViewControllerInput {
//    func selectedSlots(_ slots: Dictionary<String, Any>)
}

protocol SlotSelectionViewControllerOutput {
    
    func handleSlotSelection(withPanGesture sender:UIPanGestureRecognizer, adapter:SlotCollectionViewAdapter)
}

class SlotSelectionViewController: UIViewController, SlotSelectionViewControllerInput,SlotCollectionAdapterDelegate {
    
    var output: SlotSelectionViewControllerOutput!
    var router: SlotSelectionRouter!
    
    var collectionViewAdapter : SlotCollectionViewAdapter!
    
    var selectedSlots : Dictionary<String, Any>?
    //MARK: - Outlets
    
    @IBOutlet weak var collectionView:UICollectionView!
    
    @IBOutlet weak var friendsWhoBoughtContainerView: UIView!
   
    
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
        collectionViewAdapter.delegate = self
        collectionViewAdapter.collectionView = self.collectionView
        
        let color1 = UIColor(red: 1, green: 0.55, blue: 0.17, alpha: 1)
        let color2 = UIColor(red: 1, green: 0.39, blue: 0.13, alpha: 1)
        
        
        btnDone.applyGradient(colors: [color1, color2], direction: .leftToRight)
        DispatchQueue.main.async {
            self.btnDone.layer.cornerRadius = self.btnDone.frame.size.height/2
            self.btnDone.clipsToBounds = true
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        collectionView.reloadData()
        collectionViewAdapter.addCollectionViewGrid()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let stack = CascadingViews.imageViews(withUsers:[MFUser(),MFUser(),MFUser(),MFUser(),MFUser()], size:35)
        self.friendsWhoBoughtContainerView.addSubview(stack)
        
        stack.centerXAnchor.constraint(equalTo: self.friendsWhoBoughtContainerView.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: self.friendsWhoBoughtContainerView.centerYAnchor).isActive = true
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //        collectionViewAdapter.addCollectionViewGrid()
    }
    
    
    // MARK: - Event handling/
    
    func handlePan(_ sender:UIPanGestureRecognizer){
        output.handleSlotSelection(withPanGesture: sender, adapter: collectionViewAdapter)
    }
    
    @IBAction func dismiss(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func selectedSlotsCount(_ count:Int){
        lblSlotsPickedCount.text = "\(count) Slots Selected"
    }

    
    
    
    // MARK: - Display logic
    
}
