class LiveStreamListWorker {
    
    func getList(completion: @escaping ((_ list: [MFMedia])->Void)) {
        DatabaseGateway.sharedInstance.getLiveStreams { (liveVideo) in
            completion(liveVideo)
        }
    }
}
