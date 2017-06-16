import UIKit

protocol NearbyChefsInteractorInput {
    func loadMarkers(at location: CLLocationCoordinate2D)
    func getCurrentLocation()
    func loadCuisines()
}

protocol NearbyChefsInteractorOutput {
    func showMarkers(_ markers:[Marker])
    func setCurrentLocation(_ location: CLLocation?, error: Error?)
    func showCuisineFilters(_ filters: [CuisineFilter]?, with error: Error?)
}

class NearbyChefsInteractor: NearbyChefsInteractorInput {
    
    var output: NearbyChefsInteractorOutput!
    var worker: NearbyChefsWorker!
    var currentLocationWroker = CurrentLocationWorker()
    
    // MARK: - Business logic
    
    func loadMarkers(at location: CLLocationCoordinate2D) {
        let worker = NearbyChefsWorker()
        self.output.showMarkers(worker.prepareMarkers(for: location))
    }
    
    func getCurrentLocation() {
        self.currentLocationWroker.getCurrentLocation { (currentLocation, error) in
            self.output.setCurrentLocation(currentLocation, error: error)
        }
    }
    
    func loadCuisines() {
        let cuisineWorker = CuisineFiltreWorker()
        cuisineWorker.getCuisineFilters { (cuisines, error) in
            self.output.showCuisineFilters(cuisines, with: error)
        }
    }
}
