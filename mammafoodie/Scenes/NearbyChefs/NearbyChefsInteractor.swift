import UIKit
import GoogleMaps

protocol NearbyChefsInteractorInput {
    func loadMarkers()
}

protocol NearbyChefsInteractorOutput {
    
}

class NearbyChefsInteractor: NearbyChefsInteractorInput {
    
    var output: NearbyChefsInteractorOutput!
    var worker: NearbyChefsWorker!
    
    // MARK: - Business logic
    func loadMarkers() {
        
    }
}
