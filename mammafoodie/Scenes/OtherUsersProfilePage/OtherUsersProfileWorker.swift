import UIKit

class OtherUsersProfileWorker {
    // MARK: - Business Logic
    
//    func getDataSource(forIndex:SelectedIndexForProfile, forUserID:Int, completion:(_ dishes:[AnyHashable:Any])->()){
//        //Hit API to get dishes and call completion handler
//        //DummyData.sharedInstance.createusers()
//        
//        let userProfileData = DummyData.sharedInstance.getUserForProfilePage()
//        
//        let cookedDishes = userProfileData.cookedDishes
//        let boughtDishes = userProfileData.boughtDishes
//        let userAcitvity = userProfileData.userActivity
//        
//        print(cookedDishes)
//        
//        switch forIndex {
//        case .cooked:
//            completion(cookedDishes)
//            
//        case .bought:
//            completion(boughtDishes)
//            
//        case .activity:
//            completion(userAcitvity)
//            
//        }
//    
//    }
    
    
    func getUserDataWith(userID:String, completion: @escaping (MFUser?)->Void){
        
        DatabaseGateway.sharedInstance.getUserWith(userID: userID) { (user) in
            completion(user)
        }
    }
    
    func getDishWith(dishID:String, completion: @escaping (MFDish?)->Void) {
        
        DatabaseGateway.sharedInstance.getDishWith(dishID: dishID) { (dish) in
            completion(dish)
        }
        
    }
    
    func getActivityWith(newsFeedID:String, completion: @escaping (MFNewsFeed?)->Void){
        
        DatabaseGateway.sharedInstance.getNewsFeedWith(newsFeedID: newsFeedID) { (newsFeed) in
            completion(newsFeed)
        }
    }
    
}
