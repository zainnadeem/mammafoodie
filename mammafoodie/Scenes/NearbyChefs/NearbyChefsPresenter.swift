import UIKit

protocol NearbyChefsPresenterInput {
    func showMarkers(_ markers: [Marker])
    func setCurrentLocation(_ location: CLLocation?)
}

protocol NearbyChefsPresenterOutput: class {
    func showMarkers(markers: [Marker])
    func showCurrentLocation(_ location: CLLocation?)
}

class NearbyChefsPresenter: NearbyChefsPresenterInput {
    weak var output: NearbyChefsPresenterOutput!
    
    // MARK: - Presentation logic
    func showMarkers(_ markers: [Marker]) {
        self.output.showMarkers(markers: markers)
    }
    
    func setCurrentLocation(_ location: CLLocation?) {
        self.output.showCurrentLocation(location)
    }
}
