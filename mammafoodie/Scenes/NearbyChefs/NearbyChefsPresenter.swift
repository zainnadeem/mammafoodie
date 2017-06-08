import UIKit

protocol NearbyChefsPresenterInput {
    
}

protocol NearbyChefsPresenterOutput: class {
    func showMarkers(markers: [Marker])
}

class NearbyChefsPresenter: NearbyChefsPresenterInput {
    weak var output: NearbyChefsPresenterOutput!
    
    // MARK: - Presentation logic
    
}
