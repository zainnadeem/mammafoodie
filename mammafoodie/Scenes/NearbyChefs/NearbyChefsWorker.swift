import UIKit
import GoogleMaps

class NearbyChefsWorker : NSObject {
    // MARK: - Business Logic

}

extension NearbyChefsWorker : GMSMapViewDelegate, CLLocationManagerDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return true
    }
    
    func prepareMarkers() {
        for x in 0...50 {
            let location = CLLocationCoordinate2D.init(latitude: 40.669868 + (Double(x) * 0.015), longitude: -73.9637964 + Double(x / 10))
            _ = Marker.marker(with: "Marker + \(x)", at: location)
        }
        
        for x in 0...20 {
            let location = CLLocationCoordinate2D.init(latitude: 43.669868 + (Double(x) * 0.015), longitude: -79.9637964 + Double(x / 10))
            _ = Marker.marker(with: "Marker + \(x)", at: location)
        }
    }
    
}

