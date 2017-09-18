import UIKit
import Alamofire

class FavouritesTappedWorker {
    // MARK: - Business Logic

    func favouritesTapped(userId: String, dishID:String, selected: Bool, completion: @escaping (_ status:Bool)->Void) {
        DatabaseGateway.sharedInstance.toggleDishBookmark(userID: userId, dishID: dishID, shouldBookmark: selected)
        completion(true)
    }
}
