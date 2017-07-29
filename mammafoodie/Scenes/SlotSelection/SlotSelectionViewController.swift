import UIKit

protocol SlotSelectionViewControllerInput {
//    func selectedSlots(_ slots: Dictionary<String, Any>)
}

typealias SlotSelectionClosure = (UInt) -> Void

protocol SlotSelectionViewControllerOutput {
    func handleSlotSelection(withPanGesture sender : UIPanGestureRecognizer, adapter : SlotCollectionViewAdapter, collectionView : UICollectionView)
}

class SlotSelectionViewController: UIViewController, SlotSelectionViewControllerInput,SlotCollectionAdapterDelegate {
    
    var output: SlotSelectionViewControllerOutput!
    var router: SlotSelectionRouter!
    
    var collectionViewAdapter : SlotCollectionViewAdapter!
    
    var selectedSlots : Dictionary<String, Any>?
    
    var selectedCount : UInt = 0
    
    var selectionClosure : SlotSelectionClosure?
    
    var dish : MFDish!
    
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
        
        self.collectionViewAdapter = SlotCollectionViewAdapter()
        self.collectionViewAdapter.delegate = self
        self.collectionViewAdapter.setUpCollectionView(self.collectionView, totalSlots: dish.totalSlots, availableSlots: dish.availableSlots)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.view.addGestureRecognizer(pan)
        
        let color1 = UIColor(red: 1, green: 0.55, blue: 0.17, alpha: 1)
        let color2 = UIColor(red: 1, green: 0.39, blue: 0.13, alpha: 1)
        
        self.btnDone.applyGradient(colors: [color1, color2], direction: .leftToRight)
        DispatchQueue.main.async {
            self.btnDone.layer.cornerRadius = self.btnDone.frame.size.height/2
            self.btnDone.clipsToBounds = true
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        collectionView.reloadData()
        self.collectionViewAdapter.addCollectionViewGrid()
        
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
    }
    
    // MARK: - Event handling/
    
    func handlePan(_ sender:UIPanGestureRecognizer){
        self.output.handleSlotSelection(withPanGesture : sender, adapter : collectionViewAdapter, collectionView : self.collectionView)
    }
    
    @IBAction func dismiss(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func selectedSlotsCount(_ count:Int) {
        self.selectedCount = UInt(count)
        self.lblSlotsPickedCount.text = "\(count) Slots Selected"
    }
    
    @IBAction func onDonTap(_ sender: UIButton) {
        self.dismiss(animated: true) { 
            self.selectionClosure?(self.selectedCount)
        }
    }
    
    // MARK: - Display logic
    
}
