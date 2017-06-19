import UIKit

protocol HomeViewControllerInput {
    
}

protocol HomeViewControllerOutput {
    
}

enum HomeViewControllerScreenMode {
    case activity
    case menu
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
    @IBOutlet weak var btnIconExpandVidups: UIButton!
    @IBOutlet weak var btnIconExpandLiveVideos: UIButton!
    @IBOutlet weak var conHeightClnVidups: NSLayoutConstraint!
    @IBOutlet weak var conHeightClnLiveVideos: NSLayoutConstraint!
    @IBOutlet weak var viewLiveVideoAndVidups: UIView!
    
    @IBOutlet var viewActivityMenuChooser: UIView!
    @IBOutlet weak var imgViewMenuIcon: UIImageView!
    @IBOutlet weak var clnCuisineList: UICollectionView!
    @IBOutlet weak var btnActivity: UIButton!
    @IBOutlet weak var viewCuisineSelectionIndicator: UIView!
    @IBOutlet weak var conLeadingViewCuisineSelectionIndicator: NSLayoutConstraint!
    
    
    var isLiveVideosViewExpanded: Bool = false
    var isVidupsViewExpanded: Bool = false
    let liveVideosAdapter: HomePageLiveVideoCollectionViewAdapter = HomePageLiveVideoCollectionViewAdapter()
    let vidupsAdapter: HomePageVidupsCollectionViewAdapter = HomePageVidupsCollectionViewAdapter()
    let tableViewAdapter: HomePageTableviewAdapter = HomePageTableviewAdapter()
    let cuisineListAdapter: CuisineListCollectionViewAdapter = CuisineListCollectionViewAdapter()
    
    var screenMode: HomeViewControllerScreenMode = .activity
    
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
        
        self.tblList.tableHeaderView = self.viewLiveVideoAndVidups
        self.updateTableHeaderViewHeight(animated: false)
        
        self.setupLiveVideoCollectionViewAdapter()
        self.setupVidupCollectionViewAdapter()
        self.setupTableViewAdapter()
        self.setupCuisinesCollectionViewAdapter()
        
        self.imgViewMenuIcon.layer.cornerRadius = 5
        self.viewCuisineSelectionIndicator.layer.cornerRadius = 2
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
    
    func rotateExpandLiveVideosIcon(isLiveVideoExpanded: Bool) {
        UIView.animate(withDuration: 0.27) {
            var transformation: CGAffineTransform = CGAffineTransform.identity
            if isLiveVideoExpanded {
                transformation = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
            self.btnIconExpandLiveVideos.transform = transformation
        }
    }
    
    func rotateExpandVidupsIcon(isVidupsExpanded: Bool) {
        UIView.animate(withDuration: 0.27) {
            var transformation: CGAffineTransform = CGAffineTransform.identity
            if isVidupsExpanded {
                transformation = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
            self.btnIconExpandVidups.transform = transformation
        }
    }
    
    func expandLiveVideoView(animated: Bool) {
        self.rotateExpandLiveVideosIcon(isLiveVideoExpanded: true)
        self.liveVideosAdapter.expand(animated: animated)
    }
    
    func collapseLiveVideoView(animated: Bool) {
        self.rotateExpandLiveVideosIcon(isLiveVideoExpanded: false)
        self.liveVideosAdapter.collapse(animated: animated)
    }
    
    func updateLiveVideoCollectionView(animated: Bool, isLiveVideoExpanded: Bool) {
        self.liveVideosAdapter.updateCollectionViewLayout(animated: animated, isExpanded: isLiveVideoExpanded)
    }
    
    func expandVidupsView(animated: Bool) {
        self.rotateExpandVidupsIcon(isVidupsExpanded: true)
        self.vidupsAdapter.expand(animated: animated)
    }
    
    func collapseVidupsView(animated: Bool) {
        self.rotateExpandVidupsIcon(isVidupsExpanded: false)
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
            self.updateTableHeaderViewHeight(animated: true)
        }
        self.liveVideosAdapter.didCollapse = {
            self.updateTableHeaderViewHeight(animated: true)
        }
        self.liveVideosAdapter.didSelect = { (selectedLiveVideo) in
            print("Selected live video: \(selectedLiveVideo.id)")
        }
        self.liveVideosAdapter.didSelectViewAll = {
            print("DidSelectAll LiveVideos")
        }
    }
    
    func setupVidupCollectionViewAdapter() {
        self.vidupsAdapter.createStaticData()
        self.vidupsAdapter.conHeightCollectionView = self.conHeightClnVidups
        self.vidupsAdapter.setup(with: self.clnVidups)
        self.vidupsAdapter.didExpand = {
            self.updateTableHeaderViewHeight(animated: true)
        }
        self.vidupsAdapter.didCollapse = {
            self.updateTableHeaderViewHeight(animated: true)
        }
        self.vidupsAdapter.didSelect = { (selectedVidup) in
            print("Selected vidup: \(selectedVidup.id)")
        }
        self.vidupsAdapter.didSelectViewAll = {
            print("DidSelectAll Vidup")
        }
    }
    
    func setupTableViewAdapter() {
        self.tableViewAdapter.setup(with: self.tblList)
        self.tableViewAdapter.sectionHeaderView = self.viewActivityMenuChooser
    }
    
    func setupCuisinesCollectionViewAdapter() {
        self.cuisineListAdapter.createStaticData()
        self.cuisineListAdapter.setup(with: self.clnCuisineList)
        self.cuisineListAdapter.selectionIndicatorView = self.viewCuisineSelectionIndicator
        self.cuisineListAdapter.conLeadingViewSelectionIndicator = self.conLeadingViewCuisineSelectionIndicator
    }
    
    func updateTableHeaderViewHeight(animated: Bool) {
        guard let headerView: UIView = self.tblList.tableHeaderView else {
            print("No tableHeaderView to update")
            return
        }
        UIView.animate(withDuration: animated ? 0.27 : 0) {
            headerView.setNeedsLayout()
            headerView.layoutIfNeeded()
            var newFrame: CGRect = headerView.frame
            newFrame.size.height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height + 1
            headerView.frame = newFrame
            self.tblList.tableHeaderView = headerView
            self.view.layoutIfNeeded()
        }
    }
    
    func addShadow(to view: UIView) {
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowColor = UIColor("#040B50").cgColor
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
