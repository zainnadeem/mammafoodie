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
    @IBOutlet weak var viewActivityIcon: UIView!
    @IBOutlet weak var viewMenuIcon: UIView!
    @IBOutlet weak var clnCuisineList: UICollectionView!
    @IBOutlet weak var viewSwitchMode: UIView!
    @IBOutlet weak var viewCuisineSelectionIndicator: UIView!
    @IBOutlet weak var conLeadingViewCuisineSelectionIndicator: NSLayoutConstraint!
    @IBOutlet weak var viewOptionActivity: UIView!
    @IBOutlet weak var viewOptionMenu: UIView!
    @IBOutlet weak var conTopViewActivity: NSLayoutConstraint!
    @IBOutlet weak var btnSwitchMode: UIButton!
    
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
        self.setupCuisinesCollectionViewAdapter()
        self.setupTableViewAdapter()
        
        self.viewMenuIcon.layer.cornerRadius = 5
        self.viewActivityIcon.layer.cornerRadius = 5
        self.viewSwitchMode.layer.cornerRadius = 5
        self.viewCuisineSelectionIndicator.layer.cornerRadius = 2
        
        self.viewActivityIcon.applyGradient(colors: [#colorLiteral(red: 1, green: 0.5490196078, blue: 0.168627451, alpha: 1), #colorLiteral(red: 1, green: 0.3882352941, blue: 0.1333333333, alpha: 1)])
        self.viewMenuIcon.applyGradient(colors: [#colorLiteral(red: 1, green: 0.5490196078, blue: 0.168627451, alpha: 1), #colorLiteral(red: 1, green: 0.3882352941, blue: 0.1333333333, alpha: 1)])
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
    
    @IBAction func btnSwitchModeTapped(_ sender: UIButton) {
        if self.screenMode == .activity {
            self.switchToMenuMode()
        } else {
            self.switchToActivityMode()
        }
    }
    
    func switchToActivityMode() {
        if self.screenMode == .menu {
            UIView.animate(withDuration: 0.27, animations: {
                self.conTopViewActivity.constant = 0
                self.viewOptionActivity.superview?.layoutIfNeeded()
            })
            self.screenMode = .activity
            self.tableViewAdapter.mode = .activity
            self.tableViewAdapter.loadActivities()
            self.btnSwitchMode.isSelected = false
        }
    }
    
    func switchToMenuMode() {
        if self.screenMode == .activity {
            UIView.animate(withDuration: 0.27, animations: {
                self.conTopViewActivity.constant = -1 * self.viewOptionActivity.frame.height - 16
                self.viewOptionActivity.superview?.layoutIfNeeded()
            })
            self.screenMode = .menu
            self.tableViewAdapter.mode = .menu
            self.tableViewAdapter.loadMenu(with: self.cuisineListAdapter.selectedCuisine)
            self.btnSwitchMode.isSelected = true
        }
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
            if selectedLiveVideo.id == "-1" {
                // new. push go cook with live video selection
                //                self.performSegue(withIdentifier: "showGoCookForLiveVideo", sender: nil)
            } else {
                selectedLiveVideo.accessMode = MediaAccessUserType.viewer
            }
            self.performSegue(withIdentifier: "showLiveVideoDetails", sender: selectedLiveVideo)
        }
        self.liveVideosAdapter.didSelectViewAll = {
            self.performSegue(withIdentifier: "showLiveVideoList", sender: nil)
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
            if selectedVidup.id == "-1" {
                // new. push go cook with vidup selection
                selectedVidup.accessMode = MediaAccessUserType.owner
                //                self.performSegue(withIdentifier: "showGoCookForVidup", sender: nil)
            } else {
                selectedVidup.accessMode = MediaAccessUserType.viewer
            }
            self.performSegue(withIdentifier: "showVidupDetails", sender: selectedVidup)
        }
        self.vidupsAdapter.didSelectViewAll = {
            print("DidSelectAll Vidup")
            self.performSegue(withIdentifier: "showVidupsList", sender: nil)
        }
    }
    
    func setupTableViewAdapter() {
        self.tableViewAdapter.selectedCuisine = self.cuisineListAdapter.selectedCuisine
        self.tableViewAdapter.setup(with: self.tblList)
        self.tableViewAdapter.sectionHeaderView = self.viewActivityMenuChooser
    }
    
    func setupCuisinesCollectionViewAdapter() {
        self.cuisineListAdapter.createStaticData()
        self.cuisineListAdapter.selectionIndicatorView = self.viewCuisineSelectionIndicator
        self.cuisineListAdapter.conLeadingViewSelectionIndicator = self.conLeadingViewCuisineSelectionIndicator
        self.cuisineListAdapter.setup(with: self.clnCuisineList)
        
        self.cuisineListAdapter.didSelectCuisine = { (selectedCuisine) in
            print("Cuisine selected: \(selectedCuisine.name)")
            self.tableViewAdapter.loadMenu(with: selectedCuisine)
        }
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
        view.layer.shadowColor = #colorLiteral(red: 0.01568627451, green: 0.0431372549, blue: 0.3137254902, alpha: 1).cgColor
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
