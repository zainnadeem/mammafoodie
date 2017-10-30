import UIKit
import GoogleMaps
import MapKit

protocol NearbyChefsViewControllerInput {
    func showMarkers(markers: [Marker])
    func showCurrentLocation(_ location: CLLocation?)
    func showCuisines(_ cuisines:[MFCuisine])
}

protocol NearbyChefsViewControllerOutput {
    func loadMarkers(at location: CLLocationCoordinate2D)
    func getCurrentLocation()
    func loadCuisines()
}

var kCameraLatitude : CLLocationDegrees = 0.0
var kCameraLongitude : CLLocationDegrees = 0.0

let MFThemeColorBlue = UIColor(red: 0.09, green: 0.17, blue: 0.27, alpha: 1)

class NearbyChefsViewController: UIViewController, NearbyChefsViewControllerInput {
    
    var output: NearbyChefsViewControllerOutput!
    var router: NearbyChefsRouter!
    
    var allMarks: [Marker] = [Marker]()
    var locationManager : CLLocationManager = CLLocationManager.init()
    var clusterManager: GMUClusterManager!
    
    var searchAdapter: NearbyChefsSearchAdapter!
    var featuredMenuAdapter : FeaturedMenuCollectionViewAdapter!
    
    var cuisineFilters = [MFCuisine]()
    
    var searchResults : [MFDish]! = [MFDish]()
    
    var swipGesture : UISwipeGestureRecognizer!
    
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet weak var cuisineCollectionView: UICollectionView!
    
    @IBOutlet weak var conBottomFeaturedMenuCollectionView: NSLayoutConstraint!
    @IBOutlet weak var featuredMenuCollectionView: UICollectionView!
    @IBOutlet weak var conHeightFeaturedMenuCollectionView: NSLayoutConstraint!
    @IBOutlet weak var btnFeaturedMenu: UIButton!
    @IBOutlet weak var btnFeaturedmenuBack: UIButton!
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NearbyChefsConfigurator.sharedInstance.configure(viewController: self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func handleSwipeGesture(_ recognizer : UISwipeGestureRecognizer) {
        if recognizer.direction == .down {
            self.showFeaturedMenu(false)
        } else {
            self.showFeaturedMenu(true)
        }
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.swipGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(handleSwipeGesture(_:)))
        self.swipGesture.numberOfTouchesRequired = 1
        self.swipGesture.direction = .down
        
        self.btnFeaturedmenuBack.addGestureRecognizer(self.swipGesture)
        
        self.prepareCuisineCollectionView()
        self.prepareMap()
        self.setupSearchTextField()
        self.featuredMenuAdapter = FeaturedMenuCollectionViewAdapter()
        self.featuredMenuAdapter.prepareCollectionView(self.featuredMenuCollectionView)
        
        self.searchAdapter = NearbyChefsSearchAdapter()
        self.searchAdapter.prepare(with : self.txtSearch)
        self.searchAdapter.adapterResult = { (dishes) in
            print("Found Dishes: \(dishes)")
            DispatchQueue.main.async {
                if dishes.count < 0 {
                    self.showAlert("No Results Found", message: nil)
                }
                self.searchResults.removeAll()
                self.searchResults.append(contentsOf: dishes)
                self.reloadSearchData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.output.getCurrentLocation()
        self.featuredMenuCollectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.featuredMenuCollectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.featuredMenuCollectionView.reloadData()
    }
    
    func setupSearchTextField() {
        self.txtSearch.enablesReturnKeyAutomatically = false
        self.txtSearch.layer.cornerRadius = 18.5
        self.txtSearch.layer.shadowRadius = 5.0
        self.txtSearch.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.txtSearch.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.54).cgColor
//        init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.54).cgColor
        self.txtSearch.delegate = self
        let tintColor : UIColor = UIColor.init(red: 21.0/255.0, green: 33.0/255.0, blue: 52.0/255.0, alpha: 1)
        self.txtSearch.setLeftImage(#imageLiteral(resourceName: "iconSearch"), withPadding: CGSize.init(width: 10, height: 10), tintColor: tintColor)
        self.txtSearch.setClearTextButton(with: #imageLiteral(resourceName: "iconClearText"), withPadding: CGSize.init(width: 10, height: 10), tintColor: tintColor)
    }
    
    // MARK: - Event handling
    
    // MARK: - Display logic
    func showError(error:Error) {
        let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: { (action) in
            
        }))
        self.present(alert, animated: true) {
            
        }
    }
    
    func showFeaturedMenu(_ show : Bool) {
        if show {
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
                self.btnFeaturedmenuBack.alpha = 1
                self.conBottomFeaturedMenuCollectionView.constant = 0
                self.view.layoutIfNeeded()
            }, completion: { (finished) in
            })
        } else {
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
                self.btnFeaturedmenuBack.alpha = 0
                self.conBottomFeaturedMenuCollectionView.constant = self.conHeightFeaturedMenuCollectionView.constant * -1
                self.view.layoutIfNeeded()
            }, completion: { (finished) in
            })
        }
    }
    
    @IBAction func onHideFeaturedMenu(_ sender: UIButton) {
        let alert = UIAlertController(title: "No Featured Menu Found!", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
        }))
        self.present(alert, animated: true) {
            
        }
        //        let bottom = self.conBottomFeaturedMenuCollectionView.constant
        //        let height = self.conHeightFeaturedMenuCollectionView.constant
        //        self.showFeaturedMenu((bottom == height * -1))
    }
    
    @IBAction func btnCloseTapped(_ sender: UIButton) {
        self.dismiss(animated: true) {
            
        }
    }
}

extension NearbyChefsViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
