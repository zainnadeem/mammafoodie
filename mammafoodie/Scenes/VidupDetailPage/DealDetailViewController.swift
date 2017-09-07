import UIKit
import Firebase

protocol DealDetailViewControllerInput {
    func HideandUnhideView()
    func UpdateLikeStatus(Status:Bool)
}

protocol DealDetailViewControllerOutput {
    func setupMediaPlayer(view: UIView, user_id: String, dish_id: String, dish: MFDish?)
    func resetViewBounds(view:UIView)
    func stopTimer()
    func dishLiked(user_id:String,dish_id: String)
    func dishUnliked(user_id:String,dish_id: String)
}

class DealDetailViewController: UIViewController, DealDetailViewControllerInput {
    
    var output: DealDetailViewControllerOutput!
    var router: VidupDetailPageRouter!
    
    var gradientLayerForUserInfo: CAGradientLayer!
    
    let gradientStartColor : UIColor = UIColor.init(red: 1.0, green: 0.55, blue: 0.17, alpha: 1.0)
    let gradientEndColor : UIColor = UIColor.init(red: 1.0, green: 0.39, blue: 0.13, alpha: 1.0)
    
    //TODO: - VidUp URL and Expire Time.
    var userId:String = ""
    var DishId:String = ""
    
    var dish: MFDish?
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var lbl_Comment: UILabel!
    @IBOutlet weak var lbl_Like: UILabel!
    @IBOutlet weak var lv_Mediaview: UIView!
    @IBOutlet weak var lv_Comments: UIView!
    @IBOutlet weak var lv_ProfileDetails: UIView!
    @IBOutlet weak var lv_slotView: UIView!
    @IBOutlet weak var lbl_Timer: UILabel!
    @IBOutlet weak var mediaplayerbottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var lbtn_like: UIButton!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var user_image: UIImageView!
    @IBOutlet weak var dealImageView: UIImageView!
    @IBOutlet weak var lbl_dishName: UILabel!
    @IBOutlet weak var lbl_viewCount: UILabel!
    @IBOutlet weak var lbl_slot: UILabel!
    
    var shouldShowSlotSelection = false
    
    var timerRemainingTime: Timer?
    var observer: DatabaseConnectionObserver?
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        VidupDetailPageConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Adding Tap Gesture for Comments label
        let commenttap = UITapGestureRecognizer(target: self, action: #selector(commentbtnClicked(_:)))
        lbl_Comment.addGestureRecognizer(commenttap)
        lbl_Comment.isUserInteractionEnabled = true
        
        //add gradient effect to profile view
        let gradient = CAGradientLayer()
        gradient.frame = lv_ProfileDetails.bounds
        gradient.colors = [UIColor.darkGray.cgColor, UIColor.clear.cgColor]
        self.lv_ProfileDetails.layer.insertSublayer(gradient, at: 0)
        
        self.lv_slotView.addGradienBorder(colors: [gradientStartColor, gradientEndColor], direction: .leftToRight,borderWidth: 3.0, animated: false)
        
        if let dish = self.dish {
            self.load(new: dish)
        }
        
        if let dish = self.dish {
            var itemName: String = ""
            var contentType: String = ""
            if dish.mediaType == .vidup {
                itemName = "vidup"
                contentType = "VidupView"
            } else if dish.mediaType == .picture {
                itemName = "picture"
                contentType = "PictureView"
            } else {
                itemName = "liveVideo"
                contentType = "LiveVideoView"
            }
            
            Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
                AnalyticsParameterItemID: dish.id as NSObject,
                AnalyticsParameterItemName: itemName as NSObject,
                AnalyticsParameterContentType: contentType as NSObject
                ])
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.shouldShowSlotSelection {
            self.showSlotSelection()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.output.stopTimer()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if self.dish?.mediaType == MFDishMediaType.vidup {
            self.output.resetViewBounds(view: lv_Mediaview)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.portrait
    }
    
    // MARK: - Event handling
    @IBAction func likebtnClicked(_ sender: Any) {
        if lbtn_like.isSelected ==  true{
            lbtn_like.isSelected = false
            output.dishUnliked(user_id: userId, dish_id: DishId)
        }else{
            lbtn_like.isSelected = true
            output.dishLiked(user_id: userId, dish_id: DishId)
            animateLike()
        }
    }
    
    @IBAction func commentbtnClicked(_ sender: Any) {
        print("Comments Clicked")
    }
    
    @IBAction func closebtnClicked(_ sender: Any) {
        if self.presentingViewController != nil ||
            self.navigationController?.presentingViewController != nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Display logic
    func HideandUnhideView(){
        if lv_Comments.isHidden == true {
            lv_Comments.isHidden = false
            self.mediaplayerbottomConstraint.constant = self.lv_Comments.frame.height + 1
            lv_ProfileDetails.isHidden = false
        }else{
            lv_Comments.isHidden = true
            self.mediaplayerbottomConstraint.constant = 0
            lv_ProfileDetails.isHidden = true
        }
    }
    
    func DisplayUserInfo(UserInfo:MFUser) {
        self.lbl_UserName.text = UserInfo.name
        if let url = UserInfo.picture {
            self.user_image.sd_setImage(with: url)
        }
    }
    
    func DisplayDishInfo(DishInfo:MFDish) {
        lbl_dishName.text = DishInfo.name
        lbl_slot.text = "\(DishInfo.availableSlots)/\(DishInfo.totalSlots) Slots"
        lbl_viewCount.text = "\(DishInfo.numberOfViewers)"
        lbl_Like.text = "\(Int(DishInfo.likesCount))"
    }
    
    func UpdateLikeStatus(Status:Bool) {
        lbtn_like.isSelected = Status
    }
    
    func animateLike(){
        let imageview = UIImageView(image: #imageLiteral(resourceName: "Liked"))
        imageview.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path =  CustomPath().cgPath
        animation.duration = 1.5
        animation.fillMode = kCAFillModeRemoved
        animation.isRemovedOnCompletion = false
        imageview.layer.add(animation, forKey: "nil")
        
        UIView.animate(withDuration: 2, animations: {
            imageview.alpha = 0
        }) { (finished) in
            imageview.removeFromSuperview()
        }
        
        lv_Mediaview.addSubview(imageview)
    }
    
    func CustomPath()-> UIBezierPath {
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: self.view.frame.width-35, y: self.view.frame.height - 50))
        
        let endpoint = CGPoint(x: self.view.frame.width-35, y: self.view.frame.height - 300)
        
        let cp1 = CGPoint(x: (self.view.frame.width-35)+20, y: self.view.frame.height - 100)
        let cp2 = CGPoint(x: (self.view.frame.width-35)-20, y: self.view.frame.height - 250)
        
        path.addCurve(to: endpoint, controlPoint1: cp1, controlPoint2: cp2)
        return path
    }
    
    func load(new vidup: MFDish) {
        self.displayDishInfo(for: vidup)
        self.observer = DatabaseGateway.sharedInstance.getDishWith(dishID: vidup.id, frequency: .realtime, { (loadedDish) in
            if let loadedDish = loadedDish {
                self.displayDishInfo(for: loadedDish)
            }
        })
    }
    
    deinit {
        self.observer = nil
    }
    
    func displayDishInfo(for vidup: MFDish) {
        self.userId = vidup.user.id
        self.DishId = vidup.id
        self.dish = vidup
        
        self.displayRemainingTimeForDeal()
        
        _ = DatabaseGateway.sharedInstance.getUserWith(userID: self.userId) { (dishUser) in
            DispatchQueue.main.async {
                if let dishUser = dishUser {
                    self.DisplayUserInfo(UserInfo: dishUser)
                }
            }
        }
        
        self.DisplayDishInfo(DishInfo: vidup)
        
        if vidup.mediaType == MFDishMediaType.vidup {
            self.output.setupMediaPlayer(view: lv_Mediaview,
                                         user_id: userId ,
                                         dish_id: DishId,
                                         dish: self.dish)
        } else if vidup.mediaType == MFDishMediaType.picture {
            if let url: URL = vidup.mediaURL {
                self.dealImageView.sd_setImage(with: url)
            }
        }
    }
    
    func displayRemainingTimeForDeal() {
        
        guard let endTimestamp = self.dish?.endTimestamp else {
            return
        }
        
        if self.timerRemainingTime == nil {
            self.timerRemainingTime = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                let components: Set<Calendar.Component> = [
                    Calendar.Component.day,
                    Calendar.Component.hour,
                    Calendar.Component.minute,
                    Calendar.Component.second,
                    ]
                let datecomponents: DateComponents = Calendar.current.dateComponents(components, from: Date(), to: endTimestamp)
                
                var shouldKeepTimerAlive: Bool = false
                var timerString: [String] =  []
                
                if datecomponents.day ?? 0 > 0 {
                    shouldKeepTimerAlive = true
                    timerString.append("\(datecomponents.day!) day")
                }
                
                if datecomponents.hour ?? 0 > 0 {
                    shouldKeepTimerAlive = true
                    timerString.append(String.init(format: "%02d", datecomponents.hour!))
                } else {
                    timerString.append("00")
                }
                
                if datecomponents.minute ?? 0 > 0 {
                    shouldKeepTimerAlive = true
                    timerString.append(String.init(format: "%02d", datecomponents.minute!))
                } else {
                    timerString.append("00")
                }
                
                if datecomponents.second ?? 0 > 0 {
                    shouldKeepTimerAlive = true
                    timerString.append(String.init(format: "%02d", datecomponents.second!))
                } else {
                    timerString.append("00")
                }
                DispatchQueue.main.async {
                    if shouldKeepTimerAlive == true {
                        self.lbl_Timer.text = timerString.joined(separator: ":")
                    } else {
                        self.lbl_Timer.text = "00:00:00"
                        
                        self.timerRemainingTime?.invalidate()
                        self.timerRemainingTime = nil
                    }
                }
            })
        }
    }
    
    @IBAction func btnUserProfileTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "segueShowUserProfile", sender: self.dish!.user.id)
    }
    
    @IBAction func onSlotsTap(_ sender: UIButton) {
        self.showSlotSelection()
    }
    
    func showSlotSelection() {
        self.shouldShowSlotSelection = false
        if self.dish?.totalSlots ?? 0 > 0 &&
            self.dish?.availableSlots ?? 0 > 0 {
            self.performSegue(withIdentifier: "seguePresentSlotSelectionViewController", sender: self)
        } else {
            self.showAlert("Sorry!", message: "No slots available!")
        }
    }
    
    func purchase(slots : UInt) {
        self.performSegue(withIdentifier: "segueShowPaymentViewController", sender: slots)
    }
}

