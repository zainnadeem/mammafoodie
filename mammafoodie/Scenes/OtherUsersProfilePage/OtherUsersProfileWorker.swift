import UIKit

class OtherUsersProfileWorker {
    // MARK: - Business Logic
    
    func getDataSource(forIndex:SelectedIndexForProfile, forUserID:Int, completion:(_ dishes:[AnyHashable:Any])->()){
        //Hit API to get dishes and call completion handler
        //DummyData.sharedInstance.createusers()
        
        let userProfileData = DummyData.sharedInstance.getUserForProfilePage()
        
        let cookedDishes = userProfileData.cookedDishes
        let boughtDishes = userProfileData.boughtDishes
        let userAcitvity = userProfileData.userActivity
        
        print(cookedDishes)
        
        switch forIndex {
        case .cooked:
            completion(cookedDishes)
            
        case .bought:
            completion(boughtDishes)
            
        case .activity:
            completion(userAcitvity)
            
        }
    
    }
    
}
