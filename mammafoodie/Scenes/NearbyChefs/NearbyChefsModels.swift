import UIKit
import GoogleMaps

class Marker : GMSMarker, GMUClusterItem {
    
    var isSelected = false
    var index : Int = -1
    var dishID : String = ""
    
    class func marker(with title: String, at location: CLLocationCoordinate2D, with index : Int) -> Marker {
        let marker = Marker()
        marker.position = location
        marker.title = title
        marker.isTappable = true
        marker.icon = #imageLiteral(resourceName: "iconMarkerPin")
        marker.appearAnimation = .none
        marker.index = index
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
