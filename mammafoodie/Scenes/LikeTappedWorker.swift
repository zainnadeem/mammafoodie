import UIKit
import Alamofire

class LikeTappedWorker {
    // MARK: - Business Logic
    
    func likeTapped(userId: String, dishID:String, selected: Bool, completion: @escaping ()->Void){
        var requestURL = ""
        if selected == true {
            requestURL = "https://us-central1-mammafoodie-baf82.cloudfunctions.net/likeDish?dishId=\(dishID)&userId=\(userId)"
        }else{
            requestURL = "https://us-central1-mammafoodie-baf82.cloudfunctions.net/unlikeDish?dishId=\(dishID)&userId=\(userId)"
        }
        Alamofire.request(requestURL)
            .responseString { response in
                print(response.result.error ?? "")
        }
    }
}



