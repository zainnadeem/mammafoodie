import UIKit

class LiveVideoWorker {
    // MARK: - Business Logic
    
    var liveVideoGateway: LiveVideoGateway? = LiveVideoGateway()
    
    typealias LiveVideoViewClosure = (_ cameraView: UIView)->Void
    
    func start(_ liveVideo: MFDish, _ completion: @escaping LiveVideoViewClosure) {
        self.liveVideoGateway!.delegate = self
        self.liveVideoGateway!.getConfigurations({ (cameraView) in
            if liveVideo.accessMode == .owner {
                self.publish(liveVideo, completion)
            } else {
                self.subscribe(liveVideo, completion)
            }
        })
    }
    
    func publish(_ liveVideo: MFDish, _ completion: @escaping LiveVideoViewClosure) {
        self.liveVideoGateway!.publish(with: liveVideo.id, { (newCameraView) in
            completion(newCameraView)
            self.publishStreamToDatabase(liveVideo, completion)
        })
    }
    
    func publishStreamToDatabase(_ liveVideo: MFDish, _ completion: @escaping LiveVideoViewClosure) {
        let worker: LiveVideoPublisherWorker = LiveVideoPublisherWorker()
        worker.publishStream(with: liveVideo.id, { (liveVideo) in
        })
    }
    
    func unpublishStreamFromDatabase(_ liveVideo: MFDish) {
        let worker: LiveVideoPublisherWorker = LiveVideoPublisherWorker()
        worker.unpublishStream(liveVideo)
    }
    
    func subscribe(_ liveVideo: MFDish, _ completion: @escaping LiveVideoViewClosure) {
        self.liveVideoGateway!.subscribe(liveVideo.id, { (newCameraView) in
            completion(newCameraView)
        })
    }
    
    func stop(_ liveVideo: MFDish) {
        if liveVideo.accessMode == .owner {
            self.unpublishStreamFromDatabase(liveVideo)
        }
        self.liveVideoGateway!.stop()
    }
}

extension LiveVideoWorker: LiveVideoGatewayDelegate {
    
    func streamPublished() {
        
    }
    
    func streamSubscribed() {
        
    }
    
}
