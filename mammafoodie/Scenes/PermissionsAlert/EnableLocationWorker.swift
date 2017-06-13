import UIKit
import CoreLocation

class EnableLocationWorker  {
    
    let manager = CLLocationManager()
    
    func showDefaultLocationPermission(){
        if CLLocationManager.authorizationStatus() == .notDetermined {
            manager.requestAlwaysAuthorization()
        }

    }
    
}
