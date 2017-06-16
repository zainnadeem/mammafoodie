import UIKit
import GoogleMaps

let kClusterItemCount = 100

class NearbyChefsWorker : NSObject {
    
    // MARK: - Business Logic
    private func prepareMarkers() -> [Marker] {
        var markers = [Marker]()
        let extent = 10.9
        for index in 1...kClusterItemCount {
            let lat = kCameraLatitude + extent * randomScale()
            let lng = kCameraLongitude + extent * randomScale()
            let location = CLLocationCoordinate2D.init(latitude:lat, longitude: lng)
            markers.append(Marker.marker(with: "Marker + \(index)", at: location))
            
        }
        
        print("Preparing Markers")
        return markers
    }
    
    func prepareMarkers(for location: CLLocationCoordinate2D) -> [Marker] {
        var markers = [Marker]()
        let extent = 10.9
        for index in 1...kClusterItemCount {
            let lat = location.latitude + extent * randomScale()
            let lng = location.longitude + extent * randomScale()
            let location = CLLocationCoordinate2D.init(latitude:lat, longitude: lng)
            markers.append(Marker.marker(with: "Marker + \(index)", at: location))
        }
        
        print("Preparing Markers")
        return markers
    }
    
    private func randomScale() -> Double {
        return Double(arc4random()) / Double(UINT32_MAX) * 2.0 - 1.0
    }
}
