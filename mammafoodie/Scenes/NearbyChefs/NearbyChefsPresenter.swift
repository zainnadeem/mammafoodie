import UIKit

protocol NearbyChefsPresenterInput {
    func showMarkers(_ markers: [Marker])
    func setCurrentLocation(_ location: CLLocation?, error: Error?)
    func showCuisineFilters(_ filters: [CuisineFilter]?, with error: Error?)
}

protocol NearbyChefsPresenterOutput: class {
    func showMarkers(markers: [Marker])
    func showCurrentLocation(_ location: CLLocation?)
    func showError(error:Error)
    func showCuisines(_ cuisines:[CuisineFilter])
}

class NearbyChefsPresenter: NearbyChefsPresenterInput {
    weak var output: NearbyChefsPresenterOutput!
    
    // MARK: - Presentation logic
    func showMarkers(_ markers: [Marker]) {
        print("Asking VC to show marker at location: \(String(describing: markers.first?.position))")
        self.output.showMarkers(markers: markers)
    }
    
    func setCurrentLocation(_ location: CLLocation?, error: Error?) {
        if let er = error {
            self.output.showError(error: er)
        } else {
            self.output.showCurrentLocation(location)
        }
    }
    
    func showCuisineFilters(_ filters: [CuisineFilter]?, with error: Error?) {
        if let er = error {
            self.output.showError(error: er)
        } else {
            if let cuisines = filters {
                self.output.showCuisines(cuisines)
            }
        }
    }
    
}
