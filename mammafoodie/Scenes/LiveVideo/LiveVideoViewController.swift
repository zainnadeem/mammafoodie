import UIKit
import SDWebImage
import Firebase

protocol LiveVideoViewControllerInput {
    func show(_ cameraView: UIView)
    func showVideoId(_ liveVideo: MFDish)
    func liveVideoClosed()
    func streamUnpublished()
}

protocol LiveVideoViewControllerOutput {
    func start(_ liveVideo: MFDish)
    func stop(_ liveVideo: MFDish)
}

class LiveVideoViewController: UIViewController, LiveVideoViewControllerInput {
    
    var output: LiveVideoViewControllerOutput?
    var router: LiveVideoRouter!
    
    var countObserver: DatabaseConnectionObserver?
    var liveVideo: MFDish!
    //    var gradientLayerForUserInfo: CAGradientLayer!
    //    var gradientLayerForComments: CAGradientLayer!
    var viewCamera: UIView!
    
    @IBOutlet weak var imgViewProfilePicture: UIImageView!
    @IBOutlet weak var lblUserFullname: UILabel!
    @IBOutlet weak var viewUserInfo: UIView!
    @IBOutlet weak var lblDishName: UILabel!
    @IBOutlet weak var lblNumberOfViewers: UILabel!
    @IBOutlet weak var viewSlotDetails: UIView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var imgViewPlaceholder: UIImageView!
    @IBOutlet weak var viewVisualBlurEffect: UIVisualEffectView!
    @IBOutlet var imgViewViewers: [UIImageView]!
    @IBOutlet weak var lblLiveVideoEndedMessage: UILabel!
    @IBOutlet weak var btnCloseLiveVideo: UIButton!
    @IBOutlet weak var viewLiveVideoEnded: UIView!
    @IBOutlet weak var viewComments: CommentsView!
    
    @IBOutlet weak var lblSlotsCount: UILabel!
    
    var observer: DatabaseConnectionObserver?
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        LiveVideoConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewLiveVideoEnded.isHidden = true
        self.imgViewPlaceholder.image = nil
        
        self.imgViewProfilePicture.clipsToBounds = true
        self.imgViewProfilePicture.contentMode = .scaleAspectFill
        self.imgViewProfilePicture.layer.cornerRadius = 20
        
        self.btnClose.imageView?.contentMode = .scaleAspectFit
        
        for imgView in self.imgViewViewers {
            imgView.layer.cornerRadius = 12
            imgView.layer.borderWidth = 1
            imgView.layer.borderColor = UIColor.white.cgColor
        }
        
        self.updateShadowForButtonCloseLiveVideo()
        
        self.loadDish()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.viewWillAppearCode()
        
        self.viewSlotDetails.layer.cornerRadius = 15
        self.viewSlotDetails.addGradienBorder(colors: [#colorLiteral(red: 1, green: 0.5490196078, blue: 0.168627451, alpha: 1),#colorLiteral(red: 1, green: 0.3882352941, blue: 0.1333333333, alpha: 1)])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewComments.showLatestComment()
    }
    
    func viewWillAppearCode() {
        self.countObserver = DatabaseGateway.sharedInstance.getDishViewers(id: self.liveVideo.id) { (count) in
            self.lblNumberOfViewers.text = "\(count)"
        }

        // This needs to be executed from viewWillAppear or later. Because of the Camera
        if self.output != nil {
            #if (arch(i386) || arch(x86_64)) && os(iOS)
            #else
                //                self.output!.start(self.liveVideo)
            #endif
        }
        
        self.setupViewComments()
        self.viewComments.emojiTapped = { (emojiButton) in
            if let current = DatabaseGateway.sharedInstance.getLoggedInUser() {
                let alert = UIAlertController.init(title: "Choose amount", message: "", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction.init(title: "$1", style: .default, handler: { (action) in
                    SavedCardsVC.presentSavedCards(on : self, amount : 1.0, to : self.liveVideo.user.id, from : current.id)
                }))
                alert.addAction(UIAlertAction.init(title: "$2", style: .default, handler: { (action) in
                    SavedCardsVC.presentSavedCards(on : self, amount : 2.0, to : self.liveVideo.user.id, from : current.id)
                }))
                alert.addAction(UIAlertAction.init(title: "$3", style: .default, handler: { (action) in
                    SavedCardsVC.presentSavedCards(on : self, amount : 3.0, to : self.liveVideo.user.id, from : current.id)
                }))
                alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (action) in
                    
                }))
                self.present(alert, animated: true, completion: {
                    
                })
            }
        }

    }
    
    func loadDish() {
        self.observer = DatabaseGateway.sharedInstance.getDishWith(dishID: self.liveVideo.id, frequency: .realtime) { (dish) in
            DispatchQueue.main.async {
                if let dish = dish {
                    self.lblSlotsCount.text = "\(dish.availableSlots)/\(dish.totalSlots) Slots"
                    self.liveVideo = dish
                    self.lblDishName.text = dish.name
                    self.showUserInfo()
                    
                    
                    if let location = dish.location {
                        if (dish.address.characters.count == 0) || CLLocationCoordinate2DIsValid(location) == false {
                            self.viewSlotDetails.isHidden = true
                        }
                    } else {
                        self.viewSlotDetails.isHidden = true
                    }
                } else {
                    self.btnCloseTapped(self.btnClose)
                }
            }
        }
    }
    
    func load(new liveVideo: MFDish) {
        self.output?.stop(self.liveVideo)
        self.liveVideo = liveVideo
        self.loadDish()
        self.viewWillAppearCode()
    }
    
    func showUserInfo() {
        let userId = self.liveVideo.user.id
        DatabaseGateway.sharedInstance.getUserWith(userID: userId) { (user) in
            self.lblUserFullname.text = user?.name ?? ""
            if let url = DatabaseGateway.sharedInstance.getUserProfilePicturePath(for: user!.id) {
                self.imgViewProfilePicture.sd_setImage(with: url)
            } else {
                self.imgViewProfilePicture.image = nil
            }
        }
    }
    
    func setupViewComments() {
        self.viewComments.dish = self.liveVideo
        self.viewComments.load()
    }
    
    func updateShadowForButtonCloseLiveVideo() {
        let layer: CALayer = self.btnCloseLiveVideo.layer
        layer.cornerRadius = 5
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
    }
    
    //    func updateDropShadowForViewUserInfo() {
    //        if self.gradientLayerForUserInfo == nil {
    //            self.viewUserInfo.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    //            self.gradientLayerForUserInfo = CAGradientLayer()
    //            let view: UIView = UIView(frame: self.viewUserInfo.frame)
    //            self.gradientLayerForUserInfo.frame = view.frame
    //            self.gradientLayerForUserInfo.colors = self.colorsForUserInfoInnerGradient()
    //            self.gradientLayerForUserInfo.startPoint = CGPoint(x: 0.5, y: 0.5)
    //            self.gradientLayerForUserInfo.endPoint = CGPoint(x: 0.5, y: 1)
    //            self.viewUserInfo.superview?.layer.insertSublayer(self.gradientLayerForUserInfo, below: self.viewUserInfo.layer)
    //        }
    //    }
    
    //    func updateDropShadowForViewComments() {
    //        if self.gradientLayerForComments == nil {
    //            self.viewComments.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    //            self.gradientLayerForComments = CAGradientLayer()
    //            let view: UIView = UIView(frame: self.viewComments.frame)
    //            self.gradientLayerForComments.frame = view.frame
    //            self.gradientLayerForComments.colors = self.colorsForCommentsInnerGradient()
    //            self.gradientLayerForComments.startPoint = CGPoint(x: 0.5, y: 0)
    //            self.gradientLayerForComments.endPoint = CGPoint(x: 0.5, y: 1)
    //            self.viewComments.superview?.layer.insertSublayer(self.gradientLayerForComments, below: self.viewComments.layer)
    //        }
    //    }
    
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
            #if (arch(i386) || arch(x86_64)) && os(iOS)
            #else
                self.output!.stop(self.liveVideo)
            #endif
        }
        self.countObserver?.stop()
        self.countObserver = nil
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
        self.output?.stop(self.liveVideo)
        if self.presentingViewController != nil ||
            self.navigationController?.presentingViewController != nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Display logic
    
    func show(_ cameraView: UIView) {
        self.viewCamera = cameraView
        
        self.view.insertSubview(cameraView, aboveSubview: self.viewVisualBlurEffect)
        
        // align cameraView from the left and right
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": cameraView]));
        
        // align cameraView from the top and bottom
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": cameraView]));
        
        //        if self.liveVideo.accessMode == .viewer {
        //            self.viewCamera.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        //        }
    }
    
    func streamUnpublished() {
        self.viewLiveVideoEnded.isHidden = false
        self.viewCamera.removeFromSuperview()
    }
    
    func liveVideoClosed() {
        // Closed
    }
    
    func showVideoId(_ liveVideo: MFDish) {
        //        self.lblVideoName.text = liveVideo.id
        if liveVideo.id != nil {
            //            self.viewVisualBlurEffect.removeFromSuperview()
            //            self.imgViewPlaceholder.removeFromSuperview()
        }
    }
    
    func purchase(slots : UInt) {
        self.performSegue(withIdentifier: "segueShowPaymentViewController", sender: slots)
    }
    
    deinit {
        print("Deinit LiveVideoVC")
    }
    
    @IBAction func onSlotsTap(_ sender: UIButton) {
        if self.liveVideo.totalSlots > 0 &&
            self.liveVideo.availableSlots > 0 {
            self.performSegue(withIdentifier: "seguePresentSlotSelectionViewController", sender: self)
        } else {
            self.showAlert("Sorry!", message: "No slots available!")
        }
    }
    
    @IBAction func btnShowHideExtrasTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.27, animations: {
            let shouldHide = !self.viewUserInfo.isHidden
            self.viewUserInfo.isHidden = shouldHide
            self.viewComments.isHidden = shouldHide
            //            self.gradientLayerForComments.isHidden = shouldHide
            //            self.gradientLayerForUserInfo.isHidden = shouldHide
        }) { (isFinished) in
            if isFinished {
                print("Animation finished btnShowHideExtrasTapped")
            }
        }
    }
}
