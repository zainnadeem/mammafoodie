import UIKit

class LoadDishWorker:HUDRenderer {
    
    var observer : DatabaseConnectionObserver?
    
    func getDish(with dishID:String, completion: @escaping (MFDish?)->Void) {
        
        showActivityIndicator()
       observer =  DatabaseGateway.sharedInstance.getDishWith(dishID: dishID, frequency: .realtime) { (dish) in
//            self.hideActivityIndicator()
            completion(dish)
            
        }

    }
    
    func stopObserving(){
        self.observer?.stop()
    }
}
