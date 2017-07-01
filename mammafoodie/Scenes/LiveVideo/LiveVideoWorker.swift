import UIKit

protocol LiveVideoWorkerDelegate {
    func show(message: String)
    func liveVideoClosed()
    func liveVideoStarted()
    func liveVideoConnectionFailed()
    func streamUnpublished()
}

class LiveVideoWorker {
    // MARK: - Business Logic
    
    var liveVideoGateway: LiveVideoGateway? = LiveVideoGateway()
    var delegate: LiveVideoWorkerDelegate?
    
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
        self.liveVideoGateway!.subscribe(liveVideo.id, { (newCameraView) in
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
    
    func invalidMedia() {
        self.delegate?.liveVideoConnectionFailed()
        self.delegate?.show(message: "Invalid media")
    }
    
    func gatewayConnected() {
        self.delegate?.show(message: "Connected to the gateway")
    }
    
    func gatewayDisconnected() {
        self.delegate?.show(message: "Disconnected from the gateway")
    }
    
    func streamPublished() {
        self.delegate?.show(message: "Stream started streaming")
    }
    
    func streamSubscribed() {
        self.delegate?.liveVideoStarted()
        self.delegate?.show(message: "Stream subscribed")
    }
    
    func streamClosed() {
        self.delegate?.liveVideoClosed()
        self.delegate?.show(message: "Stream closed")
    }
    
    func unknownError(_ error: String) {
        self.delegate?.show(message: error)
    }
    
    func insufficientBandwidth() {
        self.delegate?.show(message: "Internet connection issue")
    }
    
    func streamUnpublished() {
        self.delegate?.streamUnpublished()
    }
    
}
