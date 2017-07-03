import UIKit

protocol LiveVideoPresenterInput {
    func show(message: String)
    func show(_ cameraView: UIView)
    func showVideoId(_ liveVideo: MFDish)
    func liveVideoClosed()
    func streamUnpublished()
}

protocol LiveVideoPresenterOutput: class {
    func show(_ cameraView: UIView)
    func showVideoId(_ liveVideo: MFDish)
    func liveVideoClosed()
    func streamUnpublished()
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

    func show(message: String) {
        print("=================== Message: " + message)
    }
    
    func liveVideoClosed() {
        if self.output != nil {
            self.output!.liveVideoClosed()
        }
    }
    
    func streamUnpublished() {
        self.output?.streamUnpublished()
    }

}
