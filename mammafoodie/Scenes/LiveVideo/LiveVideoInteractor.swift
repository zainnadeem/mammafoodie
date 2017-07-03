import UIKit

protocol LiveVideoInteractorInput {
    func start(_ liveVideo: MFDish)
    func stop(_ liveVideo: MFDish)
}

protocol LiveVideoInteractorOutput {
    func show(_ cameraView: UIView)
    func showVideoId(_ liveVideo: MFDish)
    func show(message: String)
    func liveVideoClosed()
    func streamUnpublished()
}

class LiveVideoInteractor: LiveVideoInteractorInput {
    
    var output: LiveVideoInteractorOutput?
    lazy var worker: LiveVideoWorker = LiveVideoWorker()
    
    // MARK: - Business logic
    
    func start(_ liveVideo: MFDish) {
        self.worker.start(liveVideo, { (cameraView) in
            if self.output != nil {
                UIApplication.shared.isIdleTimerDisabled = true
                self.output!.show(cameraView)
                self.output!.showVideoId(liveVideo)
            }
        })
    }
    
    func stop(_ liveVideo: MFDish) {
        self.worker.stop(liveVideo)
    }
}

extension LiveVideoInteractor: LiveVideoWorkerDelegate {
    func show(message: String) {
        self.output?.show(message: message)
    }
    
    func liveVideoClosed() {
        self.output?.liveVideoClosed()
    }
    
    func liveVideoStarted() {
        
    }
    
    func liveVideoConnectionFailed() {
        // Connection error here
    }
    
    func streamUnpublished() {
        self.output?.streamUnpublished()
    }
}
