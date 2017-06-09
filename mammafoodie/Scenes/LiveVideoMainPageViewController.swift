import UIKit

protocol LiveVideoMainPageViewControllerInput {
    func displayLiveVideos(_ response: LiveVideoMainPage.Response)
}

protocol LiveVideoMainPageViewControllerOutput {
    func loadLiveVideos()
 
}

class LiveVideoMainPageViewController: UIViewController,  LiveVideoMainPageViewControllerInput {
    
    var output: LiveVideoMainPageViewControllerOutput!
    var router: LiveVideoMainPageRouter!
    
    @IBAction func btnFetchVideos(_ sender: Any) {
        self.output.loadLiveVideos()
    }
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        LiveVideoMainPageConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // Mark: - Fetch Live Vids
    
    func displayLiveVideos(_ response: LiveVideoMainPage.Response) {
        print("got the live videos in the view controller")
    }
    // MARK: - Event handling
    
    // MARK: - Display logic
    
}
