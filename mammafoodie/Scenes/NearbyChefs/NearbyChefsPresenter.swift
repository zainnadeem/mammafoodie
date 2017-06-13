import UIKit

protocol NearbyChefsPresenterInput {
    func showMarkers(_ markers: [Marker])
    func setCurrentLocation(_ location: CLLocation?, error: Error?)
}

protocol NearbyChefsPresenterOutput: class {
    func showMarkers(markers: [Marker])
    func showCurrentLocation(_ location: CLLocation?)
    func showError(error:Error)
}

class NearbyChefsPresenter: NearbyChefsPresenterInput {
    weak var output: NearbyChefsPresenterOutput!
    
    // MARK: - Presentation logic
    func showMarkers(_ markers: [Marker]) {
        self.output.showMarkers(markers: markers)
    }
    
    func setCurrentLocation(_ location: CLLocation?, error: Error?) {
        if let er = error {
            self.output.showError(error: er)
        } else {
            self.output.showCurrentLocation(location)
        }
    }
}