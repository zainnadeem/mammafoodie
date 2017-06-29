import UIKit

protocol LiveVideoViewControllerInput {
    func show(_ cameraView: UIView)
    func showVideoId(_ liveVideo: MFMedia)
}

protocol LiveVideoViewControllerOutput {
    func start(_ liveVideo: MFMedia)
    func stop(_ liveVideo: MFMedia)
}

class LiveVideoViewController: UIViewController, LiveVideoViewControllerInput {
    
    var output: LiveVideoViewControllerOutput?
    var router: LiveVideoRouter!
    
    var liveVideo: MFMedia!
    var gradientLayerForUserInfo: CAGradientLayer!
    var gradientLayerForComments: CAGradientLayer!
    
    //    @IBOutlet weak var btnEndLive: UIButton!
    //    @IBOutlet weak var lblVideoName: UILabel!
    @IBOutlet weak var viewUserInfo: UIView!
    @IBOutlet weak var viewSlotDetails: UIView!
    @IBOutlet weak var viewComments: UIView!
    @IBOutlet weak var btnEmoji: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var txtNewComment: UITextView!
    @IBOutlet weak var tblComments: UITableView!
    @IBOutlet weak var btnClose: UIButton!
    
    @IBOutlet var imgViewViewers: [UIImageView]!
    
    
    lazy var commentsAdapter: CommentsTableViewAdapter = CommentsTableViewAdapter()
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        LiveVideoConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnLike.imageView?.contentMode = .scaleAspectFit
        self.btnEmoji.imageView?.contentMode = .scaleAspectFit
        self.btnClose.imageView?.contentMode = .scaleAspectFit
        self.setupCommentsTableViewAdapter()
        
        for imgView in self.imgViewViewers {
            imgView.layer.cornerRadius = 12
            imgView.layer.borderWidth = 1
            imgView.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        // This needs to be executed from viewWillAppear or later. Because of the Camera
        if self.output != nil {
            self.output!.start(self.liveVideo)
        }
        
        self.viewSlotDetails.layer.cornerRadius = 15
        self.viewSlotDetails.addGradienBorder(colors: [#colorLiteral(red: 1, green: 0.5490196078, blue: 0.168627451, alpha: 1),#colorLiteral(red: 1, green: 0.3882352941, blue: 0.1333333333, alpha: 1)])
        
        self.updateDropShadowForViewUserInfo()
        self.updateDropShadowForViewComments()
    }
    
    func updateDropShadowForViewUserInfo() {
        if self.gradientLayerForUserInfo == nil {
            self.viewUserInfo.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            self.gradientLayerForUserInfo = CAGradientLayer()
            let view: UIView = UIView(frame: self.viewUserInfo.frame)
            self.gradientLayerForUserInfo.frame = view.frame
            self.gradientLayerForUserInfo.colors = self.colorsForUserInfoInnerGradient()
            self.gradientLayerForUserInfo.startPoint = CGPoint(x: 0.5, y: 0.5)
            self.gradientLayerForUserInfo.endPoint = CGPoint(x: 0.5, y: 1)
            self.viewUserInfo.superview?.layer.insertSublayer(self.gradientLayerForUserInfo, below: self.viewUserInfo.layer)
        }
    }
    
    func updateDropShadowForViewComments() {
        if self.gradientLayerForComments == nil {
            self.viewComments.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            self.gradientLayerForComments = CAGradientLayer()
            let view: UIView = UIView(frame: self.viewComments.frame)
            self.gradientLayerForComments.frame = view.frame
            self.gradientLayerForComments.colors = self.colorsForCommentsInnerGradient()
            self.gradientLayerForComments.startPoint = CGPoint(x: 0.5, y: 0)
            self.gradientLayerForComments.endPoint = CGPoint(x: 0.5, y: 1)
            self.viewComments.superview?.layer.insertSublayer(self.gradientLayerForComments, below: self.viewComments.layer)
        }
    }
    
    func colorsForUserInfoInnerGradient() -> [CGColor] {
        return [
            #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 0.7).cgColor,
            #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 0.6).cgColor,
            #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 0.5).cgColor,
            #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 0.4).cgColor,
            #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 0.3).cgColor,
            #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 0.2).cgColor,
            #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 0.1).cgColor,
            #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0).cgColor
        ]
    }
    
    func colorsForCommentsInnerGradient() -> [CGColor] {
        return [
            #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0).cgColor,
            #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 0.1).cgColor,
            #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 0.2).cgColor,
            #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 0.3).cgColor,
            #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 0.4).cgColor,
            #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 0.5).cgColor,
            #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 0.6).cgColor,
            #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 0.7).cgColor,
            #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 0.8).cgColor,
            #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 0.9).cgColor,
            #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 1).cgColor
        ]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.output != nil {
            self.output!.stop(self.liveVideo)
        }
    }
    
    // MARK: - Event handling
    
    @IBAction func btnEndLiveTapped(_ sender: UIButton) {
        if self.output != nil {
            self.output!.stop(self.liveVideo)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnLikeTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func btnCloseTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Display logic
    
    func show(_ cameraView: UIView) {
        self.view.insertSubview(cameraView, at: 0)
        
        // align cameraView from the left and right
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": cameraView]));
        
        // align cameraView from the top and bottom
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": cameraView]));
    }
    
    func showVideoId(_ liveVideo: MFMedia) {
        //        self.lblVideoName.text = liveVideo.id
    }
    
    func setupCommentsTableViewAdapter() {
        self.commentsAdapter.createStaticData()
        self.commentsAdapter.setup(with: self.tblComments)
        self.tblComments.reloadData()
        self.tblComments.setContentOffset(CGPoint(x: 0, y: self.tblComments.contentSize.height-self.tblComments.frame.height), animated: false)
    }
    
    deinit {
        print("Deinit LiveVideoVC")
    }
    
}
