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
    
    var output: LiveVideoViewControllerOutput!
    var router: LiveVideoRouter!
    
    var liveVideo: MFMedia!
    var gradientLayer: CAGradientLayer!
    
    @IBOutlet weak var btnEndLive: UIButton!
    @IBOutlet weak var lblVideoName: UILabel!
    @IBOutlet weak var viewUserInfo: UIView!
    @IBOutlet weak var viewSlotDetails: UIView!
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        LiveVideoConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // This needs to be executed from viewWillAppear or later. Because of the Camera
        //        self.output.start(self.liveVideo)
        self.viewSlotDetails.layer.cornerRadius = 15
        self.viewSlotDetails.addGradienBorder(colors: [#colorLiteral(red: 1, green: 0.5490196078, blue: 0.168627451, alpha: 1),#colorLiteral(red: 1, green: 0.3882352941, blue: 0.1333333333, alpha: 1)])
        
        self.updateDropShadowForViewUserInfo()
    }
    
    func updateDropShadowForViewUserInfo() {
        if self.gradientLayer == nil {
            self.viewUserInfo.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            self.gradientLayer = CAGradientLayer()
            let view: UIView = UIView(frame: self.viewUserInfo.frame)
            self.gradientLayer.frame = view.bounds
            self.gradientLayer.colors = [
                #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 0.7).cgColor,
                #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 0.6).cgColor,
                #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 0.5).cgColor,
                #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 0.4).cgColor,
                #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 0.3).cgColor,
                #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 0.2).cgColor,
                #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 0.1).cgColor,
                #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0).cgColor
            ]
            self.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
            self.gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
            self.viewUserInfo.superview?.layer.insertSublayer(self.gradientLayer, below: self.viewUserInfo.layer)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.output.stop(self.liveVideo)
    }
    
    // MARK: - Event handling
    
    @IBAction func btnEndLiveTapped(_ sender: UIButton) {
        self.output.stop(self.liveVideo)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Display logic
    
    func show(_ cameraView: UIView) {
        self.view.addSubview(cameraView)
        
        // align cameraView from the left and right
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": cameraView]));
        
        // align cameraView from the top and bottom
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": cameraView]));
    }
    
    func showVideoId(_ liveVideo: MFMedia) {
        self.lblVideoName.text = liveVideo.id
    }
}
