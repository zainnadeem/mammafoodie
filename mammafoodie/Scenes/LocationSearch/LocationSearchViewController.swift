import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

protocol LocationSearchViewControllerInput {
    
}

protocol LocationSearchViewControllerOutput {
    
}

class LocationSearchViewController: UIViewController, LocationSearchViewControllerInput {
    
    var output: LocationSearchViewControllerOutput!
    var router: LocationSearchRouter!
    
    let locationManager = CLLocationManager()
    
    var searchAdapter : LocationSearchAdapter!
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        LocationSearchConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        searchAdapter = LocationSearchAdapter()
        searchAdapter.setupSearchBar(in: self.view)
    }
    
    
}
