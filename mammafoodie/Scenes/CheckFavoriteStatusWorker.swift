import UIKit

class CheckFavoriteStatusWorker {
    // MARK: - Business Logic
    
    func checkStatus(userId: String, dishId:String, completion: @escaping (Bool?)->Void) {
        DatabaseGateway.sharedInstance.checkSavedDishes(userId: userId, dishId: dishId) { (status) in
            
            completion(status)
        }
        
    }

}
