import UIKit

protocol VidupDetailPageViewControllerInput {
    func HideandUnhideView()
    func DisplayTime(Time:String)
}

protocol VidupDetailPageViewControllerOutput {
    func setupMediaPlayer(view:UIView,mediaURL:String)
    func resetViewBounds(view:UIView)
    func stopTimer()
}

class VidupDetailPageViewController: UIViewController, VidupDetailPageViewControllerInput {
    
    var output: VidupDetailPageViewControllerOutput!
    var router: VidupDetailPageRouter!
    
    var gradientLayerForUserInfo: CAGradientLayer!
    
    let gradientStartColor : UIColor = UIColor.init(red: 1.0, green: 0.55, blue: 0.17, alpha: 1.0)
    let gradientEndColor : UIColor = UIColor.init(red: 1.0, green: 0.39, blue: 0.13, alpha: 1.0)
    
    //FIXME: - Input need to be passed to ViewController
    
    var vidupURL:String = "https://static.videezy.com/system/resources/previews/000/002/212/original/Puffins-Lunga-TreshnishIsles-hd-stock-video.mp4"
    
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
        
        output.setupMediaPlayer(view: lv_Mediaview, mediaURL: vidupURL)
        
        
        // FIXME: Check during API Call
        lbtn_like.isSelected = true
        
        
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
        }else{
            lbtn_like.isSelected = true
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

}

