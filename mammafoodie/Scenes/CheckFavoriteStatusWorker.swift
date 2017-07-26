import UIKit

class CheckFavoriteStatusWorker {
    // MARK: - Business Logic
    
    func checkStatus(userId: String, dishId:String, completion: @escaping (Bool?)->Void) {
        
        DatabaseGateway.sharedInstance.checkIfDishBookMarked(dishID: dishId, userID: userId) { (status) in
            completion(status)
        }
    }

}
