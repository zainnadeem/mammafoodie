import UIKit
import GoogleMaps

//struct NearbyChefs {
//    struct ChefLocation {
//        struct Request {
//        }
//        struct Response {
//        }
//        struct ViewModel {
//        }
//    }
//}

class Marker : GMSMarker, GMUClusterItem {
    
    var isSelected = false
//    var position: CLLocationCoordinate2D
//    var title: String
    
//    init(with name: String, at location: CLLocationCoordinate2D) {
//        self.position = location
//        self.title = name
//        self.appearAnimation = .pop
//    }

    class func marker(with title: String, at location: CLLocationCoordinate2D) -> Marker {
        let marker = Marker()
        marker.position = location
        marker.title = title
        marker.isTappable = true
        marker.appearAnimation = .pop
        return marker
    }
    
    static func ==(lhs: Marker, rhs: Marker) -> Bool {
        if lhs.position.latitude != rhs.position.latitude {
            return false
        }
        
        if lhs.position.longitude != rhs.position.longitude {
            return false
        }
        return true
    }

}
