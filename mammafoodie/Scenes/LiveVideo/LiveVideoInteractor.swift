import UIKit

protocol LiveVideoInteractorInput {
    func start(_ liveVideo: MFMedia)
    func stop(_ liveVideo: MFMedia)
}

protocol LiveVideoInteractorOutput {
    func show(_ cameraView: UIView)
    func showVideoId(_ liveVideo: MFMedia)
}

class LiveVideoInteractor: LiveVideoInteractorInput {
    
    var output: LiveVideoInteractorOutput?
    lazy var worker: LiveVideoWorker = LiveVideoWorker()
    
    // MARK: - Business logic
    
    func start(_ liveVideo: MFMedia) {
        self.worker.start(liveVideo, { (cameraView) in
            if self.output != nil && cameraView != nil {
                self.output!.show(cameraView)
                self.output!.showVideoId(liveVideo)
            }
        })
    }
    
    func stop(_ liveVideo: MFMedia) {
        self.worker.stop(liveVideo)
    }
}
