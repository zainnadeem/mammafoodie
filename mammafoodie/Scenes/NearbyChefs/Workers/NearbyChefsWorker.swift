import UIKit
import GoogleMaps
import GeoFire
import Firebase

let kClusterItemCount = 100
var searchRadius : Double = 10.0

typealias MarkerCompletion = ([Marker]) -> Void

class NearbyChefsWorker : NSObject {
    
    var geoFire : GeoFire!
    var geoQuery : GFQuery!
    var queryObserver : UInt?
    
    private var completion : MarkerCompletion?
    
    private var allMarkers : [Marker] = [Marker]()
    
    override init() {
        super.init()
        let firebaseRef = Database.database().reference().child("NearbyChefs").ref
        self.geoFire = GeoFire.init(firebaseRef: firebaseRef)
    }
    
    // MARK: - Business Logic
    private func prepareMarkers() -> [Marker] {
        var markers = [Marker]()
        let extent = 10.9
        for index in 1...kClusterItemCount {
            let lat = kCameraLatitude + extent * randomScale()
            let lng = kCameraLongitude + extent * randomScale()
            let location = CLLocationCoordinate2D.init(latitude:lat, longitude: lng)
            markers.append(Marker.marker(with: "Marker + \(index)", at: location, with: -1))
            
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
            markers.append(Marker.marker(with: "Marker + \(index)", at: location, with: -1))
        }
        
        print("Preparing Markers")
        return markers
    }
    
    func prepareMarkers(for location: CLLocationCoordinate2D, completion : @escaping MarkerCompletion) {
        let clloc = CLLocation.init(latitude: location.latitude, longitude: location.longitude)
        self.removeQueryobserver()
        self.allMarkers.removeAll()
        self.completion = completion
        self.fetchLocations(for: clloc)
    }
    
    private func fetchLocations(for location: CLLocation) {
        let span = MKCoordinateSpanMake(0.5, 0.5)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        self.geoQuery = self.geoFire.query(with: region)
        print("Querying GeoFire For location: \(location) for Worker")
        self.queryObserver =  self.geoQuery.observe(.keyEntered) { (key, markerLocation) in
            if let k = key {
                if let markLoc = markerLocation {
                    let mark = Marker.marker(with: k, at: markLoc.coordinate, with: -1)
                    if !self.allMarkers.contains(mark) {
                        self.allMarkers.append(mark)
                    }
                    self.completion?(self.allMarkers)
                } else {
                    print("Found Geo Mark without location for Key: \(k)")
                }
            } else {
                print("Found Geo Mark without Key")
            }
        }
        self.geoQuery.observeReady {
            print("Query stopped")
            self.removeQueryobserver()
            if self.allMarkers.count > 0 {
                self.completion?(self.allMarkers)   
            }
        }
    }
    
    private func removeQueryobserver() {
                    print("Query stopped")
        if let observer = self.queryObserver {
            self.geoQuery.removeObserver(withFirebaseHandle: observer)
        }
    }
    
    private func randomScale() -> Double {
        return Double(arc4random()) / Double(UINT32_MAX) * 2.0 - 1.0
    }
}
