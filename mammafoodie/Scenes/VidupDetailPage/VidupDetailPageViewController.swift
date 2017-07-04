import UIKit

protocol VidupDetailPageViewControllerInput {
    func HideandUnhideView()
    func DisplayTime(Time:String)
    func DisplayUserInfo(UserInfo:MFUser)
    func DisplayDishInfo(DishInfo:MFDish,MediaInfo:MFDish)
}

protocol VidupDetailPageViewControllerOutput {
    func setupMediaPlayer(view:UIView,user_id:String,dish_id: String)
    func resetViewBounds(view:UIView)
    func stopTimer()
    func dishLiked(user_id:String,dish_id: String)
    func dishUnliked(user_id:String,dish_id: String)
}

class VidupDetailPageViewController: UIViewController, VidupDetailPageViewControllerInput {
    
    var output: VidupDetailPageViewControllerOutput!
    var router: VidupDetailPageRouter!
    
    var gradientLayerForUserInfo: CAGradientLayer!
    
    let gradientStartColor : UIColor = UIColor.init(red: 1.0, green: 0.55, blue: 0.17, alpha: 1.0)
    let gradientEndColor : UIColor = UIColor.init(red: 1.0, green: 0.39, blue: 0.13, alpha: 1.0)
    
    //TODO: - VidUp URL and Expire Time.
    var userId:String = "Ki1ChCPqXuTBlMA485OPVAbjK6C2"
    var DishId:String = "KnmktPhvbyk0EAfUWd7"
    
    
    
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
    @IBOutlet weak var lbl_dishName: UILabel!
    @IBOutlet weak var lbl_viewCount: UILabel!
    @IBOutlet weak var lbl_slot: UILabel!
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        VidupDetailPageConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Adding Tap Gesture for Comments label
        let commenttap = UITapGestureRecognizer(target: self, action: #selector(commentbtnClicked(_:)))
        lbl_Comment.addGestureRecognizer(commenttap)
        lbl_Comment.isUserInteractionEnabled = true
        
        //add gradient effect to profile view
        let gradient = CAGradientLayer()
        gradient.frame = lv_ProfileDetails.bounds
        gradient.colors = [UIColor.darkGray.cgColor, UIColor.clear.cgColor]
        lv_ProfileDetails.layer.insertSublayer(gradient, at: 0)
        
        lv_slotView.addGradienBorder(colors: [gradientStartColor,gradientEndColor], direction: .leftToRight,borderWidth: 3.0, animated: false)
        
        output.setupMediaPlayer(view: lv_Mediaview, user_id: userId , dish_id: DishId)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.output.stopTimer()
    }
    
    override func viewWillLayoutSubviews() {
        output.resetViewBounds(view: lv_Mediaview)
    }
    
    override var prefersStatusBarHidden: Bool{
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
        print("Close Clicked")
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
    
    func DisplayTime(Time:String){
        lbl_Timer.text = Time
    }
    
    func DisplayUserInfo(UserInfo:MFUser) {
        lbl_UserName.text = UserInfo.name
        if let url = NSURL(string: UserInfo.picture!) {
            if let data = NSData(contentsOf: url as URL) {
                user_image.image = UIImage(data: data as Data)
            }
        }
    }
    
    func DisplayDishInfo(DishInfo:MFDish,MediaInfo:MFDish) {
        lbl_dishName.text = DishInfo.name!
        lbl_slot.text = "\(DishInfo.availableSlots)/\(DishInfo.totalSlots) Slots"
        lbl_viewCount.text = "\(MediaInfo.numberOfViewers)"
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
        
        UIView.animate(withDuration: 2  , animations: {
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
    
}

