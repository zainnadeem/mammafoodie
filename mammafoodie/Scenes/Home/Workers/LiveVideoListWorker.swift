import Foundation

class LiveVideoListWorker {
    
    var observer: DatabaseConnectionObserver?
    
    func getList(_ completion: @escaping (([MFDish])->Void)) {
        self.observer = DatabaseGateway.sharedInstance.getLiveVideos { (dishes) in
            let filteredDishes: [MFDish] = dishes.filter { (dish) -> Bool in
                return dish.visible
            }
            completion(filteredDishes)
        }
    }
}
