import UIKit

class LiveVideoWorker {
    // MARK: - Business Logic
    
    var liveVideoGateway: LiveVideoGateway? = LiveVideoGateway()
    
    typealias LiveVideoViewClosure = (_ cameraView: UIView)->Void
    
    func start(_ liveVideo: MFMedia, _ completion: @escaping LiveVideoViewClosure) {
        self.liveVideoGateway!.delegate = self
        self.liveVideoGateway!.getConfigurations({ (cameraView) in
            if liveVideo.accessMode == .owner {
                self.publish(liveVideo, completion)
            } else {
                self.subscribe(liveVideo, completion)
            }
        })
    }
    
    func publish(_ liveVideo: MFMedia, _ completion: @escaping LiveVideoViewClosure) {
        self.liveVideoGateway!.publish(with: liveVideo.id, { (newCameraView) in
            completion(newCameraView)
            self.publishStreamToDatabase(liveVideo, completion)
        })
    }
    
    func publishStreamToDatabase(_ liveVideo: MFMedia, _ completion: @escaping LiveVideoViewClosure) {
        let worker: LiveVideoPublisherWorker = LiveVideoPublisherWorker()
        worker.publishStream(with: liveVideo.id, { (liveVideo) in
        })
    }
    
    func unpublishStreamFromDatabase(_ liveVideo: MFMedia) {
        let worker: LiveVideoPublisherWorker = LiveVideoPublisherWorker()
        worker.unpublishStream(liveVideo)
    }
    
    func subscribe(_ liveVideo: MFMedia, _ completion: @escaping LiveVideoViewClosure) {
        self.liveVideoGateway!.subscribe(liveVideo.contentId, { (newCameraView) in
            completion(newCameraView)
        })
    }
    
    func stop(_ liveVideo: MFMedia) {
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
