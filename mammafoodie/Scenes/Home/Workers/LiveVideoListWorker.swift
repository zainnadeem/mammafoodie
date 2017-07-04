import Foundation

class LiveVideoListWorker {
    
    var observer: DatabaseConnectionObserver?
    
    func getList(_ completion: @escaping (([MFDish])->Void)) {
        self.observer = DatabaseGateway.sharedInstance.getLiveVideos { (dishes) in
            completion(dishes)
        }
    }
}
