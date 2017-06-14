import UIKit
import GoogleMaps
import GooglePlaces

class LocationSearchWorker {
    
    class func setup() {
        let googleMapsApiKey = "AIzaSyBjxYTYWAt6WIjy0ahVBigO7Im0SRu2yug"
        
        GMSServices.provideAPIKey(googleMapsApiKey)
        GMSPlacesClient.provideAPIKey(googleMapsApiKey)
        
    }
}
