import UIKit
import GoogleMaps
//import GoogleMapsCore

class Marker : GMSMarker, GMUClusterItem {
    
    var isSelected = false
    var index : Int = -1
    var isDish: Bool = true
    var refrenceID : String = ""
    
//    class func marker(with title: String, at location: CLLocationCoordinate2D, with index : Int) -> Marker {
//        let marker = Marker()
//        marker.position = location
//        marker.title = title
//        marker.isDish = true
//        marker.isTappable = true
//        marker.icon = #imageLiteral(resourceName: "iconMarkerPin")
//        marker.appearAnimation = .none
//        marker.index = index
//        return marker
//    }
    
    class func marker(withTitle title: String, atLocation location: CLLocationCoordinate2D, withIndex index : Int, withID refid: String, isDish isa: Bool) -> Marker {
        let marker = Marker()
        marker.position = location
        marker.title = title
        marker.isDish = isa
        marker.refrenceID = refid
        if isa {
            marker.icon = #imageLiteral(resourceName: "iconMarkerPinUser")
        } else {
            marker.icon = #imageLiteral(resourceName: "iconMarkerPin")
        }
        marker.isTappable = true
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
