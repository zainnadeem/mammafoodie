import UIKit

protocol LiveVideoPresenterInput {
    func show(_ cameraView: UIView)
    func showVideoId(_ liveVideo: MFDish)
}

protocol LiveVideoPresenterOutput: class {
    func show(_ cameraView: UIView)
    func showVideoId(_ liveVideo: MFDish)
}

class LiveVideoPresenter: LiveVideoPresenterInput {
    weak var output: LiveVideoPresenterOutput?
    
    // MARK: - Presentation logic
    
    func show(_ cameraView: UIView) {
        if self.output != nil {
            self.output!.show(cameraView)
        }
    }
    
    func showVideoId(_ liveVideo: MFDish) {
        if self.output != nil {
            self.output!.showVideoId(liveVideo)
        }
    }
}
