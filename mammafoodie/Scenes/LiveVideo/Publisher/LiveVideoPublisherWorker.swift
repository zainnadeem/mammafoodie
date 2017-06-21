class LiveVideoPublisherWorker {
    // MARK: - Business Logic

    func publishStream(with name: String, _ completion: @escaping ((MFMedia?)->Void)) {
        DatabaseGateway.sharedInstance.publishNewLiveStream(with: name) { (newLiveStream) in
            completion(newLiveStream)
        }
    }
    
    func unpublishStream(_ liveStream: MFMedia) {
        DatabaseGateway.sharedInstance.unpublishLiveStream(liveStream) {
            
        }
    }
}
