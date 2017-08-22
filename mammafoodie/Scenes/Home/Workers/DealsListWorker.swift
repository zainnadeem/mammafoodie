import Foundation

class DealsListWorker {
    
    var vidupsObserver: DatabaseConnectionObserver?
    var picturesObserver: DatabaseConnectionObserver?
    
    var vidups: [MFDish] = []
    var pictures: [MFDish] = []
    
    func getList(_ completion: @escaping (([MFDish])->Void)) {
        self.vidupsObserver = DatabaseGateway.sharedInstance.getVidups { (dishes) in
            self.vidups = dishes
            completion(self.getCombinedList())
        }
        self.picturesObserver = DatabaseGateway.sharedInstance.getPictures { (dishes) in
            self.pictures = dishes
            completion(self.getCombinedList())
        }
    }
    
    private func getCombinedList() -> [MFDish] {
        return vidups + pictures
    }
}