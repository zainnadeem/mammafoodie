import UIKit

class RequestDishWorker {
    // MARK: - Business Logic
    func dish(dishName:String,dishNo:String, completion: @escaping (_ success:Bool, _ errorMessage:String?)->()){
        completion(true, "")
    }

}
