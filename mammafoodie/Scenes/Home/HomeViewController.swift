import UIKit

protocol HomeViewControllerInput {
    
}

protocol HomeViewControllerOutput {
    
}

enum HomeViewControllerScreenMode {
    case activity
    case menu
}

class HomeViewController: UIViewController, HomeViewControllerInput, CircleTransitionPresentAnimationDelegate {
    
    var output: HomeViewControllerOutput!
    var router: HomeRouter!
    
    var startCircleFrame: CGRect = .zero
    
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
    var conHeightViewTableViewHeader: NSLayoutConstraint!
    
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
        
        self.tblList.tableHeaderView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.setupLiveVideoCollectionViewAdapter()
        self.setupVidupCollectionViewAdapter()
        self.setupTableViewAdapter()
        
        self.viewMenuIcon.layer.cornerRadius = 5
        self.viewActivityIcon.layer.cornerRadius = 5
        self.viewSwitchMode.layer.cornerRadius = 5
        
        self.viewActivityIcon.applyGradient(colors: [#colorLiteral(red: 1, green: 0.5490196078, blue: 0.168627451, alpha: 1), #colorLiteral(red: 1, green: 0.3882352941, blue: 0.1333333333, alpha: 1)])
        self.viewMenuIcon.applyGradient(colors: [#colorLiteral(red: 1, green: 0.5490196078, blue: 0.168627451, alpha: 1), #colorLiteral(red: 1, green: 0.3882352941, blue: 0.1333333333, alpha: 1)])
        
        self.addShadow(to: self.viewLiveVideos)
        self.addShadow(to: self.viewVidups)
        
        self.addConstraints(to: self.viewLiveVideoAndVidups, in: self.tblList)
        
        self.isLiveVideosViewExpanded = false
        self.collapseLiveVideoView(animated: false)
        
        self.isVidupsViewExpanded = false
        self.collapseVidupsView(animated: false)
        
        self.updateLiveVideoCollectionView(animated: false, isLiveVideoExpanded: self.isLiveVideosViewExpanded)
        self.updateVidupsCollectionView(animated: false, isVidupsExpanded: self.isVidupsViewExpanded)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - Event handling
    
    @IBAction func btnExpandLiveVideosTapped(_ sender: UIButton) {
        if self.isLiveVideosViewExpanded {
            self.collapseLiveVideoView(animated: true)
        } else {
            self.expandLiveVideoView(animated: true)
        }
        self.isLiveVideosViewExpanded  = !self.isLiveVideosViewExpanded
        self.updateLiveVideoCollectionView(animated: !self.isLiveVideosViewExpanded, isLiveVideoExpanded: self.isLiveVideosViewExpanded)
    }
    
    @IBAction func btnExpandVidupsTapped(_ sender: UIButton) {
        if self.isVidupsViewExpanded {
            self.collapseVidupsView(animated: true)
        } else {
            self.expandVidupsView(animated: true)
        }
        self.isVidupsViewExpanded  = !self.isVidupsViewExpanded
        self.updateVidupsCollectionView(animated: !self.isVidupsViewExpanded, isVidupsExpanded: self.isVidupsViewExpanded)
    }
    
    @IBAction func btnSwitchModeTapped(_ sender: UIButton) {
        
        let shouldResetContentOffset: Bool = self.tblList.contentOffset.y > self.viewLiveVideoAndVidups.frame.height
        let newContentOffset: CGPoint = CGPoint(x: 0, y: self.viewLiveVideoAndVidups.frame.height)
        
        if self.isLiveVideosViewExpanded || self.isVidupsViewExpanded {
            
        }
        if self.screenMode == .activity {
            self.switchToMenuMode()
        } else {
            self.switchToActivityMode()
        }
        
        if shouldResetContentOffset {
            self.tblList.setContentOffset(newContentOffset, animated: false)
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
            self.tableViewAdapter.loadMenu()
            self.btnSwitchMode.isSelected = true
        }
    }
    
    // MARK: - Display logic
    
    func addConstraints(to headerView: UIView, in tableView: UITableView) {
        if self.conHeightViewTableViewHeader == nil {
            // align headerView from the left and right
            tableView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": headerView]));
            
            // align headerView from the top
            tableView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": headerView]));
            
            tableView.addConstraint(NSLayoutConstraint(item: headerView,
                                                       attribute: NSLayoutAttribute.width,
                                                       relatedBy: NSLayoutRelation.equal,
                                                       toItem: tableView,
                                                       attribute: NSLayoutAttribute.width,
                                                       multiplier: 1,
                                                       constant: 0))
            
            let height: CGFloat = self.viewLiveVideoAndVidups.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
            self.conHeightViewTableViewHeader = NSLayoutConstraint(item: headerView,
                                                                   attribute: NSLayoutAttribute.height,
                                                                   relatedBy: NSLayoutRelation.equal,
                                                                   toItem: nil,
                                                                   attribute: NSLayoutAttribute.notAnAttribute,
                                                                   multiplier: 1,
                                                                   constant: height)
            tableView.addConstraint(self.conHeightViewTableViewHeader)
        }
    }
    
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
        
        UIView.animate(withDuration: animated ? 0.27 : 0, animations: {
            self.conHeightViewTableViewHeader.isActive = false
            self.liveVideosAdapter.expand(animated: false)
            self.updateTableHeaderViewHeight()
        }) { (isCompleted) in
            print("Live video view expanded")
        }
    }
    
    func collapseLiveVideoView(animated: Bool) {
        self.rotateExpandLiveVideosIcon(isLiveVideoExpanded: false)
        
        UIView.animate(withDuration: animated ? 0.27 : 0, animations: {
            self.conHeightViewTableViewHeader.isActive = false
            self.liveVideosAdapter.collapse(animated: false)
            self.updateTableHeaderViewHeight()
        }) { (isCompleted) in
            print("Live video view collapsed")
        }
    }
    
    func updateLiveVideoCollectionView(animated: Bool, isLiveVideoExpanded: Bool) {
        self.liveVideosAdapter.updateCollectionViewLayout(animated: animated, isExpanded: isLiveVideoExpanded)
    }
    
    func expandVidupsView(animated: Bool) {
        self.rotateExpandVidupsIcon(isVidupsExpanded: true)
        UIView.animate(withDuration: animated ? 0.27 : 0, animations: {
            self.conHeightViewTableViewHeader.isActive = false
            self.vidupsAdapter.expand(animated: false)
            self.updateTableHeaderViewHeight()
        }) { (isCompleted) in
            print("Vidups view expanded")
        }
    }
    
    func collapseVidupsView(animated: Bool) {
        self.rotateExpandVidupsIcon(isVidupsExpanded: false)
        
        UIView.animate(withDuration: animated ? 0.27 : 0, animations: {
            self.conHeightViewTableViewHeader.isActive = false
            self.vidupsAdapter.collapse(animated: animated)
            self.updateTableHeaderViewHeight()
        }) { (isCompleted) in
            print("Vidups view collapsed")
        }
    }
    
    func updateVidupsCollectionView(animated: Bool, isVidupsExpanded: Bool) {
        self.vidupsAdapter.updateCollectionViewLayout(animated: animated, isExpanded: isVidupsExpanded)
    }
    
    func setupLiveVideoCollectionViewAdapter() {
        self.liveVideosAdapter.loadLiveVideos()
        self.liveVideosAdapter.conHeightCollectionView = self.conHeightClnLiveVideos
        self.liveVideosAdapter.setup(with: self.clnLiveVideos)
        self.liveVideosAdapter.didSelect = { (selectedLiveVideo, cellFrame) in
            print("Selected live video: \(selectedLiveVideo.id)")
            if selectedLiveVideo.id == "-1" {
                // new. push go cook with live video selection
                self.performSegue(withIdentifier: "segueGoCook", sender: MFDishMediaType.liveVideo)
            } else {
                selectedLiveVideo.accessMode = MFDishMediaAccessMode.viewer
                self.startCircleFrame = self.clnLiveVideos.convert(cellFrame, to: self.view)
                self.performSegue(withIdentifier: "segueShowLiveVideoDetails", sender: selectedLiveVideo)
            }
        }
        self.liveVideosAdapter.didSelectViewAll = { (cellFrame) in
            self.startCircleFrame = self.clnLiveVideos.convert(cellFrame, to: self.view)
            self.performSegue(withIdentifier: "segueShowLiveVideoList", sender: nil)
        }
    }
    
    func setupVidupCollectionViewAdapter() {
        self.vidupsAdapter.loadVidup()
        self.vidupsAdapter.conHeightCollectionView = self.conHeightClnVidups
        self.vidupsAdapter.setup(with: self.clnVidups)
        self.vidupsAdapter.didSelect = { (selectedVidup, cellFrame) in
            print("Selected vidup: \(selectedVidup.id)")
            if selectedVidup.id == "-1" {
                // new. push go cook with vidup selection
                selectedVidup.accessMode = MFDishMediaAccessMode.owner
                self.performSegue(withIdentifier: "segueGoCook", sender: MFDishMediaType.vidup)
            } else {
                selectedVidup.accessMode = MFDishMediaAccessMode.viewer
                self.startCircleFrame = self.clnVidups.convert(cellFrame, to: self.view)
                self.performSegue(withIdentifier: "segueShowVidupDetails", sender: selectedVidup)
            }
        }
        self.vidupsAdapter.didSelectViewAll = { (cellFrame) in
            self.startCircleFrame = self.clnVidups.convert(cellFrame, to: self.view)
            self.performSegue(withIdentifier: "segueShowVidupsList", sender: nil)
        }
    }
    
    func setupTableViewAdapter() {
        self.tableViewAdapter.setup(with: self.tblList)
        self.tableViewAdapter.sectionHeaderView = self.viewActivityMenuChooser
        self.tableViewAdapter.loadMenu()
    }
    
    func updateTableHeaderViewHeight() {
        guard let headerView: UIView = self.tblList.tableHeaderView else {
            print("No tableHeaderView to update")
            return
        }
        var frame = headerView.frame
        frame.size.height = self.viewLiveVideoAndVidups.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        headerView.frame = frame
        self.tblList.tableHeaderView = headerView
        self.view.layoutIfNeeded()
        self.conHeightViewTableViewHeader.constant = self.viewLiveVideoAndVidups.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        self.conHeightViewTableViewHeader.isActive = true
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
    
    func openDishDetails(_ dish: MFDish) {
        self.startCircleFrame = CGRect(origin: self.view.center, size: CGSize(width: 1, height: 1))
        dish.accessMode = .owner
        if dish.mediaType == .liveVideo {
            self.performSegue(withIdentifier: "segueShowLiveVideoDetails", sender: dish)
        } else if dish.mediaType == .vidup {
            self.performSegue(withIdentifier: "segueShowVidupDetails", sender: dish)
        }
    }
    
    @IBAction func logout(){
        
        let firebaseWorker: FirebaseLoginWorker = FirebaseLoginWorker()
        
        firebaseWorker.signOut(){ errorMessage in
            
            if errorMessage != nil {
                print(errorMessage)
            } else {
                print("Logged out successfully")
                self.navigationController?.popViewController(animated: true)
            }
            
        }
    }
    
}
