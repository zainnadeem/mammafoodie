import UIKit

class LoadLiveVideosWorker {
    // MARK: - Business Logic
   
    var observer: DatabaseConnectionObserver?
    
    func getList(_ completion: @escaping (([MFDish])->Void)) {
        self.observer = DatabaseGateway.sharedInstance.getLiveVideos { (dishes) in
            completion(dishes)
        }
    }

}
