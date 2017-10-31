import UIKit
import Alamofire

class RequestDishWorker {
    // MARK: - Business Logic
    func requestDish(dish:MFDish,quantity:Int, conversationId: String, completion: @escaping (_ success:Bool, _ errorMessage:String?)->()){
        
        guard let currentUser: MFUser = DatabaseGateway.sharedInstance.getLoggedInUser() else {return}
      
        if dish.user.id == currentUser.id {
            print("Can't request own dish!")
            return
        }
        
        let requestURL = "https://us-central1-mammafoodie-baf82.cloudfunctions.net/requestDish?dishId=\(dish.id)&dishName=\(dish.name)&userId=\(currentUser.id)&userFullname=\(currentUser.name!)&quantity=\(quantity)&conversationId=\(conversationId)"
        
        Alamofire.request(requestURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            .responseString { response in
                
                if response.result.error != nil {
//                    print(response.result.error?.localizedDescription)
                    completion(false, "error")
                } else {
                    
//                    print(response.result)
                    
                    completion(true,nil)
                }
        }
   
    }

}
