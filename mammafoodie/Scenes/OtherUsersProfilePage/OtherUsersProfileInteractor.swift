import UIKit

protocol OtherUsersProfileInteractorInput {
    func setUpDishCollectionView(_ collectionView:UICollectionView, _ profileType:ProfileType)
//    func loadDishCollectionViewForIndex(_ index:SelectedIndexForProfile)
    func loadUserProfileData(userID:String)
}

protocol OtherUsersProfileInteractorOutput {
    func openDishPageWith(dishID:Int)
}

///Defined in OtherUsersProfileInteractor
enum SelectedIndexForProfile {
    case cooked
    case bought
    case activity
}

class OtherUsersProfileInteractor: OtherUsersProfileInteractorInput, DishesCollectionViewAdapterDelegate , HUDRenderer {
    
    var output: OtherUsersProfileInteractorOutput!
    var worker: OtherUsersProfileWorker! = OtherUsersProfileWorker()
    
    var dishCollectionViewAdapter:DishesCollectionViewAdapter!
    
    var user:MFUser? {
        didSet{
            self.loadDishCollectionViewForIndex(.cooked)
        }
    }
    
    
    // MARK: - Business logic
    
    
    
    //MARK: - Input
    
    func setUpDishCollectionView(_ collectionView:UICollectionView, _ profileType:ProfileType){
        dishCollectionViewAdapter = DishesCollectionViewAdapter()
        dishCollectionViewAdapter.delegate = self
        dishCollectionViewAdapter.profileType = profileType
        dishCollectionViewAdapter.collectionView = collectionView
        dishCollectionViewAdapter.selectedIndexForProfile = .cooked
    }
    
    func loadUserProfileData(userID:String) {
        self.showActivityIndicator()
        worker.getUserDataWith(userID: userID) { (user) in
            
            self.user = user
            self.dishCollectionViewAdapter.userData = user
            self.dishCollectionViewAdapter.selectedIndexForProfile = .cooked
            self.hideActivityIndicator()
            
        }
        
        worker.getFollowersForUser(userID: userID) { (followers) in
            self.dishCollectionViewAdapter.followers = followers
        }
        
        worker.getFollowingForUser(userID: userID) { (following) in
            self.dishCollectionViewAdapter.following = following
        }
        
    }
    
    
    func loadDishCollectionViewForIndex(_ index:SelectedIndexForProfile){
        
        
        
        guard let user = self.user else {return}
        
        self.showActivityIndicator()
        
        switch index {
        case .cooked:
            
            worker.getCookedDishesForUser(userID: user.id, { (cookedDishes) in
                self.dishCollectionViewAdapter.selectedIndexForProfile = .cooked
                self.dishCollectionViewAdapter.cookedDishData = cookedDishes
            })
            
            
            
        case .bought:
            
          worker.getBoughtDishesForUser(userID: user.id, { (boughtDishes) in
            self.dishCollectionViewAdapter.selectedIndexForProfile = .bought
            self.dishCollectionViewAdapter.boughtDishData = boughtDishes

          })
            
            
        case .activity:
            
            var activities = [MFNewsFeed]()
            
//            for newsFeedID in user.userActivity.keys{
//                worker.getActivityWith(newsFeedID: newsFeedID, completion: { (newsFeed) in
//                    if newsFeed != nil {
//                        activities.append(newsFeed!)
//                    }
//                })
//            }
            
            dishCollectionViewAdapter.selectedIndexForProfile = .activity
            dishCollectionViewAdapter.activityData = activities
            
        }
        
        self.hideActivityIndicator()
        
    }
    
    
    
    //MARK: - DishesCollectionViewAdapterDelegate 
    
    func openDishPageWith(dishID:Int){
        
       output.openDishPageWith(dishID: dishID)
    
    }
    
}
