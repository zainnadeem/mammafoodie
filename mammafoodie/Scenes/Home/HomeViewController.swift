import UIKit

protocol HomeViewControllerInput {
    
}

protocol HomeViewControllerOutput {
    
}

class HomeViewController: UIViewController, HomeViewControllerInput {
    
    var output: HomeViewControllerOutput!
    var router: HomeRouter!
    
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var viewLiveVideos: UIView!
    @IBOutlet weak var clnLiveVideos: UICollectionView!
    @IBOutlet weak var viewVidups: UIView!
    @IBOutlet weak var clnVidups: UICollectionView!
    @IBOutlet weak var btnExpandLiveVideosView: UIButton!
    @IBOutlet weak var btnExpandVidupsView: UIButton!
    @IBOutlet weak var conHeightClnVidups: NSLayoutConstraint!
    @IBOutlet weak var conHeightClnLiveVideos: NSLayoutConstraint!
    
    var isLiveVideosViewExpanded: Bool = false
    var isVidupsViewExpanded: Bool = false
    let liveVideosAdapter: HomePageLiveVideoCollectionViewAdapter = HomePageLiveVideoCollectionViewAdapter()
    let vidupsAdapter: HomePageVidupsCollectionViewAdapter = HomePageVidupsCollectionViewAdapter()
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        HomeConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addArc(to: self.btnExpandLiveVideosView)
        self.addArc(to: self.btnExpandVidupsView)
        self.setupLiveVideoCollectionViewAdapter()
        self.setupVidupCollectionViewAdapter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addShadow(to: self.viewLiveVideos)
        self.addShadow(to: self.viewVidups)
        
        self.isLiveVideosViewExpanded = false
        self.collapseLiveVideoView(animated: false)
        self.updateLiveVideoCollectionView(animated: false, isLiveVideoExpanded: self.isLiveVideosViewExpanded)
        
        self.isVidupsViewExpanded = false
        self.collapseVidupsView(animated: false)
        self.updateVidupsCollectionView(animated: false, isVidupsExpanded: self.isVidupsViewExpanded)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Event handling
    
    @IBAction func btnExpandLiveVideosTapped(_ sender: UIButton) {
        if self.isLiveVideosViewExpanded {
            self.collapseLiveVideoView(animated: true)
        } else {
            self.expandLiveVideoView(animated: true)
        }
        self.isLiveVideosViewExpanded  = !self.isLiveVideosViewExpanded
        self.updateLiveVideoCollectionView(animated: false, isLiveVideoExpanded: self.isLiveVideosViewExpanded)
    }
    
    @IBAction func btnExpandVidupsTapped(_ sender: UIButton) {
        if self.isVidupsViewExpanded {
            self.collapseVidupsView(animated: true)
        } else {
            self.expandVidupsView(animated: true)
        }
        self.isVidupsViewExpanded  = !self.isVidupsViewExpanded
        self.updateVidupsCollectionView(animated: false, isVidupsExpanded: self.isVidupsViewExpanded)
    }
    
    // MARK: - Display logic
    
    func expandLiveVideoView(animated: Bool) {
        self.liveVideosAdapter.expand(animated: animated)
    }
    
    func collapseLiveVideoView(animated: Bool) {
        self.liveVideosAdapter.collapse(animated: animated)
    }
    
    func updateLiveVideoCollectionView(animated: Bool, isLiveVideoExpanded: Bool) {
        self.liveVideosAdapter.updateCollectionViewLayout(animated: animated, isExpanded: isLiveVideoExpanded)
    }
    
    func expandVidupsView(animated: Bool) {
        self.vidupsAdapter.expand(animated: animated)
    }
    
    func collapseVidupsView(animated: Bool) {
        self.vidupsAdapter.collapse(animated: animated)
    }
    
    func updateVidupsCollectionView(animated: Bool, isVidupsExpanded: Bool) {
        self.vidupsAdapter.updateCollectionViewLayout(animated: animated, isExpanded: isVidupsExpanded)
    }
    
    func setupLiveVideoCollectionViewAdapter() {
        self.liveVideosAdapter.createStaticData()
        self.liveVideosAdapter.conHeightCollectionView = self.conHeightClnLiveVideos
        self.liveVideosAdapter.setup(with: self.clnLiveVideos)
        self.liveVideosAdapter.didExpand = {
            self.updateTableHeaderViewHeight()
        }
        self.liveVideosAdapter.didCollapse = {
            self.updateTableHeaderViewHeight()
        }
        self.liveVideosAdapter.didSelect = { (selectedLiveVideo) in
            print("Selected live video: \(selectedLiveVideo.id)")
        }
    }
    
    func setupVidupCollectionViewAdapter() {
        self.vidupsAdapter.createStaticData()
        self.vidupsAdapter.conHeightCollectionView = self.conHeightClnVidups
        self.vidupsAdapter.setup(with: self.clnVidups)
        self.vidupsAdapter.didExpand = {
            self.updateTableHeaderViewHeight()
        }
        self.vidupsAdapter.didCollapse = {
            self.updateTableHeaderViewHeight()
        }
        self.vidupsAdapter.didSelect = { (selectedVidup) in
            print("Selected vidup: \(selectedVidup.id)")
        }
    }
    
    func updateTableHeaderViewHeight() {
        guard let headerView: UIView = self.tblList.tableHeaderView else {
            print("No tableHeaderView to update")
            return
        }
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        var newFrame: CGRect = headerView.frame
        newFrame.size.height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height + 1
        headerView.frame = newFrame
        self.tblList.tableHeaderView = headerView
        self.view.layoutIfNeeded()
    }
    
    func addShadow(to view: UIView) {
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowColor = UIColor(css: "040B50").cgColor
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.1
    }
    
    func addArc(to button: UIButton) {
        let arcCenter: CGPoint = CGPoint(x: button.bounds.size.width / 2, y: 0)
        let circlePath = UIBezierPath(arcCenter: arcCenter, radius: button.bounds.size.height, startAngle: 0.0, endAngle: CGFloat(Double.pi), clockwise: true)
        let circleShape = CAShapeLayer()
        circleShape.path = circlePath.cgPath
        button.layer.mask = circleShape
    }
}
