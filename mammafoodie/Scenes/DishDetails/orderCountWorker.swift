import UIKit

class orderCountWorker {
    
    
    func getOrderCount(dishID:String, completion: @escaping (Int)->Void) {
        
        DatabaseGateway.sharedInstance.getordersWith { (order) in
            
            print(order)
            
            
        }
        
    }
}
