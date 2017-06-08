import UIKit
import GoogleMaps

protocol NearbyChefsViewControllerInput {
    func showMarkers(markers: [Marker])
}

protocol NearbyChefsViewControllerOutput {
    func loadMarkers()
}

class NearbyChefsViewController: UIViewController, NearbyChefsViewControllerInput, NearbyChefsSearchAdapterResult {
    
    var output: NearbyChefsViewControllerOutput!
    var router: NearbyChefsRouter!
    
    var searchAdapter: NearbyChefsSearchAdapter!
    var locationManager : CLLocationManager = CLLocationManager.init()

    
    var markers = [Marker]()
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NearbyChefsConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchAdapter = NearbyChefsSearchAdapter(with: self)
        self.searchAdapter.setupSearchBar(in: self.searchView)
        
        self.mapView.isMultipleTouchEnabled = true
        self.output.loadMarkers()
    }
    
    func showMarkers(markers: [Marker]) {
        let groupPath = GMSMutablePath()
        for marker in markers {
            marker.map = self.mapView
            groupPath.add(marker.position)
        }
        let bounds = GMSCoordinateBounds.init(path: groupPath)
        self.mapView.animate(with: GMSCameraUpdate.fit(bounds))
    }
    
    // MARK: - Event handling
    func adapterCompleted(with result: CuisineLocation) {
        print("Display Cuisine: \(result.cuisine)")
    }
    
    
    // MARK: - Display logic
    
}
