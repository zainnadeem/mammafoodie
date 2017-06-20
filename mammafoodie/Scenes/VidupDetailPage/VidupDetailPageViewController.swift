import UIKit

protocol VidupDetailPageViewControllerInput {
    func HideandUnhideView()
}

protocol VidupDetailPageViewControllerOutput {
    func setupMediaPlayer(view:UIView,mediaURL:String)
    func resetViewBounds(view:UIView)
}

class VidupDetailPageViewController: UIViewController, VidupDetailPageViewControllerInput {
    
    var output: VidupDetailPageViewControllerOutput!
    var router: VidupDetailPageRouter!
    
    
    var seconds = 240 //This variable will hold a starting value of seconds. It could be any amount above 0.
    var timer = Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    
    //VidUp URL
    
    var vidupURL:String = "https://static.videezy.com/system/resources/previews/000/002/212/original/Puffins-Lunga-TreshnishIsles-hd-stock-video.mp4"
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var lbl_Comment: UILabel!
    @IBOutlet weak var lbl_Like: UILabel!
    @IBOutlet weak var lv_Mediaview: UIView!
    @IBOutlet weak var lv_Comments: UIView!
    @IBOutlet weak var lv_ProfileDetails: UIView!
     @IBOutlet weak var lbl_Timer: UILabel!
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        VidupDetailPageConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        runTimer()
        // Adding Tap Gesture for Comments label
        let commenttap = UITapGestureRecognizer(target: self, action: #selector(commentbtnClicked(_:)))
        lbl_Comment.addGestureRecognizer(commenttap)
        lbl_Comment.isUserInteractionEnabled = true
        
        //add gradient effect to profile view
        let gradient = CAGradientLayer()
        gradient.frame = lv_ProfileDetails.bounds
        gradient.colors = [UIColor.gray.cgColor, UIColor.clear.cgColor]
        
        lv_ProfileDetails.layer.insertSublayer(gradient, at: 0)
        
        output.setupMediaPlayer(view: lv_Mediaview, mediaURL: vidupURL)
    }
    
    override func viewWillLayoutSubviews() {
        output.resetViewBounds(view: lv_Mediaview)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.portrait
    }
    
    // MARK: - Event handling
    @IBAction func likebtnClicked(_ sender: Any) {
        print("LikeClicked")
    }
    
    @IBAction func commentbtnClicked(_ sender: Any) {
        print("Comments Clicked")
    }
    
    // MARK: - Display logic
    
    func HideandUnhideView(){
        if lv_Comments.isHidden == true {
            lv_Comments.isHidden = false
            lv_Mediaview.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height - 51)
            lv_ProfileDetails.isHidden = false
        }else{
            lv_Comments.isHidden = true
            lv_Mediaview.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height)
            lv_ProfileDetails.isHidden = true
        }
    }
    
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func updateTimer() {
        seconds -= 1     //This will decrement(count down)the seconds.
        lbl_Timer.text = timeString(time: TimeInterval(seconds))
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
}

