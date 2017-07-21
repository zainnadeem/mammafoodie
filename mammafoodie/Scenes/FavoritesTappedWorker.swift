import UIKit
import Alamofire

class FavoritesTappedWorker {
    // MARK: - Business Logic

    func favoritesTapped(userId: String, dishID:String, selected: Bool, completion: @escaping (_ status:Bool)->Void){
        
        DatabaseGateway.sharedInstance.toggleDishBookmark(userID: userId, dishID: dishID, shouldBookmark: selected) { (status) in
            completion(status)
        }
        
    }
}
