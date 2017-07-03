import UIKit
import Alamofire

class FavoritesTappedWorker {
    // MARK: - Business Logic

    func favoritesTapped(userId: String, dishID:String, selected: Bool, completion: @escaping ()->Void){
        var requestURL = ""
        if selected == true {
            requestURL = ""
        }else{
            requestURL = ""
        }
        Alamofire.request(requestURL)
            .responseString { response in
                print(response.result.error ?? "")
        }

    }
}
