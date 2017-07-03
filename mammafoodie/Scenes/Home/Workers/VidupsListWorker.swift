import Foundation

class VidupListWorker {
    
    var observer: DatabaseConnectionObserver?
    
    func getList(_ completion: @escaping (([MFDish])->Void)) {
        self.observer = DatabaseGateway.sharedInstance.getVidups { (dishes) in
            completion(dishes)
        }
    }
}
