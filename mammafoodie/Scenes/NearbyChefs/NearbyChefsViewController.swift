import UIKit
import GoogleMaps
import MapKit

protocol NearbyChefsViewControllerInput {
    func showMarkers(markers: [Marker])
    func showCurrentLocation(_ location: CLLocation?)
    func showCuisines(_ cuisines:[CuisineFilter])
}

protocol NearbyChefsViewControllerOutput {
    func loadMarkers(at location: CLLocationCoordinate2D)
    func getCurrentLocation()
    func loadCuisines()
}

var kCameraLatitude : CLLocationDegrees = 0.0
var kCameraLongitude : CLLocationDegrees = 0.0

let MFThemeColorBlue = UIColor(red: 0.09, green: 0.17, blue: 0.27, alpha: 1)

class NearbyChefsViewController: UIViewController, NearbyChefsViewControllerInput, NearbyChefsSearchAdapterResult {
    
    var output: NearbyChefsViewControllerOutput!
    var router: NearbyChefsRouter!
    
    var allMarks: [Marker] = [Marker]()
    var locationManager : CLLocationManager = CLLocationManager.init()
    var clusterManager: GMUClusterManager!
    
    var searchAdapter: NearbyChefsSearchAdapter!
    
    var cuisineFilters = [CuisineFilter]()
    var selectedFilter : CuisineFilter?
    
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var cuisineCollectionView: UICollectionView!
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NearbyChefsConfigurator.sharedInstance.configure(viewController: self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareMap()
        self.prepareCuisineCollectionView()
        self.setupSearchTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.output.getCurrentLocation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func setupSearchTextField() {
        self.txtSearch.enablesReturnKeyAutomatically = false
        self.txtSearch.layer.cornerRadius = 22.5
        self.txtSearch.layer.shadowRadius = 5.0
        self.txtSearch.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.txtSearch.layer.shadowColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.54).cgColor
        self.txtSearch.delegate = self
        let tintColor : UIColor = UIColor.init(red: 21.0/255.0, green: 33.0/255.0, blue: 52.0/255.0, alpha: 1)
        self.txtSearch.setLeftImage(#imageLiteral(resourceName: "iconSearch"), withPadding: CGSize.init(width: 15, height: 15), tintColor: tintColor)
        self.txtSearch.setClearTextButton(with: #imageLiteral(resourceName: "iconClearText"), withPadding: CGSize.init(width: 15, height: 15), tintColor: tintColor)
    }
    
    // MARK: - Event handling
    func didSelect(cusine: CuisineLocation) {
        print("Selected Cuisine: \(cusine.name)")
    }
    
    // MARK: - Display logic
    func showError(error:Error) {
        let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: { (action) in
            
        }))
        self.present(alert, animated: true) {
            
        }
    }
}

extension NearbyChefsViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
