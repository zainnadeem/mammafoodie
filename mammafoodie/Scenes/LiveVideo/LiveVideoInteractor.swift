import UIKit

protocol LiveVideoInteractorInput {
    func start(_ liveVideo: MFDish)
    func stop(_ liveVideo: MFDish)
}

protocol LiveVideoInteractorOutput {
    func show(_ cameraView: UIView)
    func showVideoId(_ liveVideo: MFDish)
}

class LiveVideoInteractor: LiveVideoInteractorInput {
    
    var output: LiveVideoInteractorOutput?
    lazy var worker: LiveVideoWorker = LiveVideoWorker()
    
    // MARK: - Business logic
    
    func start(_ liveVideo: MFDish) {
        self.worker.start(liveVideo, { (cameraView) in
            if self.output != nil && cameraView != nil {
                self.output!.show(cameraView)
                self.output!.showVideoId(liveVideo)
            }
        })
    }
    
    func stop(_ liveVideo: MFDish) {
        self.worker.stop(liveVideo)
    }
}
