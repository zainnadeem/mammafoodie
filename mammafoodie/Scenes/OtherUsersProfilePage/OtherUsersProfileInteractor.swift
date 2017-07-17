import UIKit

protocol OtherUsersProfileInteractorInput {
    func setUpDishCollectionView(_ collectionView:UICollectionView, _ profileType:ProfileType)
//    func loadDishCollectionViewForIndex(_ index:SelectedIndexForProfile)
    func loadUserProfileData(userID:String)
    
    func toggleFollow(userID:String, shouldFollow:Bool)
    
}

protocol OtherUsersProfileInteractorOutput {
    func openDishPageWith(dishID:Int)
    func openFollowers(followers:Bool, userList:[MFUser])
    func openFavouriteDishes()
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
        
        worker.getCookedDishesForUser(userID: userID, { (cookedDishes) in
            self.dishCollectionViewAdapter.cookedDishData = cookedDishes
        })
        
        worker.getBoughtDishesForUser(userID: userID, { (boughtDishes) in
            self.dishCollectionViewAdapter.boughtDishData = boughtDishes
            
        })
        
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
    
    func toggleFollow(userID:String, shouldFollow:Bool){
        
        guard let currentUser = (UIApplication.shared.delegate as! AppDelegate).currentUserFirebase else {return}
        
        worker.toggleFollow(targetUser: userID, currentUser: currentUser.uid, targetUserName: self.user!.name, currentUserName: "Current username", shouldFollow: shouldFollow) { (success) in
            
            if success {
                print("follow toggled")
            }
            
        }
        
    }
    
    //MARK: - DishesCollectionViewAdapterDelegate 
    
    func openDishPageWith(dishID:Int){
        
       output.openDishPageWith(dishID: dishID)
    
    }
    
    func openFavouriteDishes(){
        output.openFavouriteDishes()
    }
    
    func openFollowers(followers:Bool, userList:[MFUser]){
        output.openFollowers(followers: followers, userList:userList)
    }
    
}
