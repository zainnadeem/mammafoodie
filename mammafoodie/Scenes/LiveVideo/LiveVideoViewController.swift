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
    
    @IBOutlet weak var btnEndLive: UIButton!
    @IBOutlet weak var lblVideoName: UILabel!
    
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
        self.output.start(liveVideo)
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
