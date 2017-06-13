import UIKit
import GoogleMaps
import MapKit

protocol NearbyChefsViewControllerInput {
    func showMarkers(markers: [Marker])
    func showCurrentLocation(_ location: CLLocation?)
}

protocol NearbyChefsViewControllerOutput {
    func loadMarkers()
    func loadMarkers(at location: CLLocationCoordinate2D)
    func getCurrentLocation()
}

var kCameraLatitude = 40.669868
var kCameraLongitude = -73.9637964

class NearbyChefsViewController: UIViewController, NearbyChefsViewControllerInput, NearbyChefsSearchAdapterResult {
    
    var output: NearbyChefsViewControllerOutput!
    var router: NearbyChefsRouter!
    
    var allMarks: [Marker] = [Marker]()
    
    var searchAdapter: NearbyChefsSearchAdapter!
    var locationManager : CLLocationManager = CLLocationManager.init()
    
    
    var markers = [Marker]()
    
    private var clusterManager: GMUClusterManager!
    
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
        self.prepareMap()
        self.output.getCurrentLocation()
    }
    
    func prepareMap() {
        self.mapView.isMultipleTouchEnabled = true
        
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: self.mapView, clusterIconGenerator: iconGenerator)
        self.clusterManager = GMUClusterManager(map: self.mapView, algorithm: algorithm, renderer: renderer)
        self.clusterManager.setDelegate(self, mapDelegate: self)
        
        if let jsonPathURL = Bundle.main.url(forResource: "MapStyle", withExtension: "json") {
            print("path: \(String(describing: jsonPathURL))")
            do {
                let jsonString = try String.init(contentsOf: jsonPathURL)
                self.mapView.mapStyle = try GMSMapStyle(jsonString: jsonString)
            } catch {
                print("failed to load. \(error)")
            }
        }
        
    }
    
    func showMarkers(markers: [Marker]) {
        for marker in markers {
            if !self.allMarks.contains(marker) {
                self.clusterManager.add(marker)
                self.allMarks.append(marker)
            } else {
                print("Found Duplicate")
            }
        }
        print("Total Pins: \(self.clusterManager.algorithm.allItems().count)")
        self.clusterManager.cluster()
        //        let camera = GMSCameraPosition.camera(withLatitude: kCameraLatitude, longitude: kCameraLongitude, zoom: 10)
        //        self.mapView.animate(to: camera)
    }
    
    // MARK: - Event handling
    func didSelect(cusine: CuisineLocation) {
        print("Selected Cuisine: \(cusine.name)")
    }
    
    
    // MARK: - Display logic
    func showCurrentLocation(_ location: CLLocation?) {
        if let currentLocation = location {
            kCameraLatitude = currentLocation.coordinate.latitude
            kCameraLongitude = currentLocation.coordinate.longitude
            self.output.loadMarkers()
        } else {
            print("Location not found")
        }
    }
    
    func showError(error:Error) {
        let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: { (action) in
            
        }))
        self.present(alert, animated: true) { 
            
        }
    }
}

extension NearbyChefsViewController : GMUClusterManagerDelegate, GMSMapViewDelegate, GMUClusterRendererDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let poiItem = marker.userData as? Marker {
            NSLog("Did tap marker for cluster item \(String(describing: poiItem.title))")
        } else {
            NSLog("Did tap a normal marker")
        }
        return true
    }
    
    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {
        print("Beautify your marker here!")
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.output.loadMarkers(at: position.target)
        print("idle At: \(position.target)")
    }
}
