import UIKit

class LoadDishWorker {
    
    
    func getDish(with dishID:String, completion: @escaping (MFDish?)->Void) {
        DatabaseGateway.sharedInstance.getDishWith(dishID: dishID, frequency: .realtime) { (dish) in
    
            completion(dish)
            
        }

    }
}
