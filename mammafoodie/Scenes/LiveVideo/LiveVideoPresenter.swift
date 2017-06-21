import UIKit

protocol LiveVideoPresenterInput {
    func show(_ cameraView: UIView)
    func showVideoId(_ liveVideo: MFMedia)
}

protocol LiveVideoPresenterOutput: class {
    func show(_ cameraView: UIView)
    func showVideoId(_ liveVideo: MFMedia)
}

class LiveVideoPresenter: LiveVideoPresenterInput {
    weak var output: LiveVideoPresenterOutput!
    
    // MARK: - Presentation logic
    
    func show(_ cameraView: UIView) {
        self.output.show(cameraView)
    }
    
    func showVideoId(_ liveVideo: MFMedia) {
        self.output.showVideoId(liveVideo)
    }
}
