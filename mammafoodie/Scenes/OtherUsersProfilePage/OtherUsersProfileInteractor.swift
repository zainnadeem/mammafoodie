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

class OtherUsersProfileInteractor: OtherUsersProfileInteractorInput, DishesCollectionViewAdapterDelegate {
    
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
    }
    
    func loadUserProfileData(userID:String) {
        worker.getUserDataWith(userID: userID) { (user) in
            
            self.user = user
            self.dishCollectionViewAdapter.userData = user
            self.dishCollectionViewAdapter.selectedIndexForProfile = .cooked
            
        }
    }
    
    
    func loadDishCollectionViewForIndex(_ index:SelectedIndexForProfile){
        
        guard let user = self.user else {return}
        
        switch index {
        case .cooked:
            
            var cookedDishes = [MFDish]()
            
            for dishID in user.cookedDishes.keys{
                worker.getDishWith(dishID: dishID , completion: { (dish) in
                    if dish != nil {
                       cookedDishes.append(dish!)
                    }
                })
            }
            
            dishCollectionViewAdapter.dishData = cookedDishes
            dishCollectionViewAdapter.selectedIndexForProfile = .cooked
            
        case .bought:
            
            var boughtDishes = [MFDish]()
            
            for dishID in user.boughtDishes.keys{
                worker.getDishWith(dishID: dishID , completion: { (dish) in
                    if dish != nil {
                        boughtDishes.append(dish!)
                    }
                })
            }
            
            dishCollectionViewAdapter.dishData = boughtDishes
            dishCollectionViewAdapter.selectedIndexForProfile = .bought
            
        case .activity:
            
            var activities = [MFNewsFeed]()
            
            for newsFeedID in user.userActivity.keys{
                worker.getActivityWith(newsFeedID: newsFeedID, completion: { (newsFeed) in
                    if newsFeed != nil {
                        activities.append(newsFeed!)
                    }
                })
            }
            
            dishCollectionViewAdapter.activityData = activities
            
        }
        
    }
    
    
    
    //MARK: - DishesCollectionViewAdapterDelegate 
    
    func openDishPageWith(dishID:Int){
        
       output.openDishPageWith(dishID: dishID)
    
    }
    
}
