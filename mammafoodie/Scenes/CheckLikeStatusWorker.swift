import UIKit

class CheckLikeStatusWorker {
    // MARK: - Business Logic

    func checkStatus(userId: String, dishId:String, completion: @escaping (Bool?)->Void) {
        DatabaseGateway.sharedInstance.checkLikedDishes(userId: userId, dishId: dishId) { (status) in
            
            completion(status)
        }
        
        
    }


}
