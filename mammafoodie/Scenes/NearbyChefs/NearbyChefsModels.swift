import UIKit
import GoogleMaps

class Marker : GMSMarker, GMUClusterItem {
    
    var isSelected = false

    class func marker(with title: String, at location: CLLocationCoordinate2D) -> Marker {
        let marker = Marker()
        marker.position = location
        marker.title = title
        marker.isTappable = true
        marker.icon = #imageLiteral(resourceName: "iconMarkerPin")
        marker.appearAnimation = .none
        return marker
    }
    
    static func ==(lhs: Marker, rhs: Marker) -> Bool {
//        if lhs.position.latitude != rhs.position.latitude {
//            return false
//        }
//        
//        if lhs.position.longitude != rhs.position.longitude {
//            return false
//        }
        return lhs.title == rhs.title
    }

}
