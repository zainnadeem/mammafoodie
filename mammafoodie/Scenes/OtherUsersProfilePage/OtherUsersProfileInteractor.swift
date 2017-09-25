import UIKit

protocol OtherUsersProfileInteractorInput {
    func setUpDishCollectionView(_ collectionView:UICollectionView, _ profileType:ProfileType)
    //    func loadDishCollectionViewForIndex(_ index:SelectedIndexForProfile)
    func loadUserProfileData(userID:String)
    func deallocDatabaseObserver()
    func toggleFollow(userID:String, shouldFollow:Bool)
    
}

protocol OtherUsersProfileInteractorOutput {
    func openDishPageWith(dishID:String)
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
    var worker: OtherUsersProfileWorker = OtherUsersProfileWorker()
    var dishCollectionViewAdapter: DishesCollectionViewAdapter!
    var user: MFUser? {
        didSet {
            self.loadCountsForAllSections()
            self.loadDishCollectionViewForIndex(SelectedIndexForProfile.cooked)
        }
    }
    
    //MARK: - Input
    func setUpDishCollectionView(_ collectionView:UICollectionView, _ profileType:ProfileType) {
        self.dishCollectionViewAdapter = DishesCollectionViewAdapter()
        self.dishCollectionViewAdapter.delegate = self
        self.dishCollectionViewAdapter.profileType = profileType
        self.dishCollectionViewAdapter.collectionView = collectionView
        self.dishCollectionViewAdapter.selectedIndexForProfile = .cooked
    }
    
    func deallocDatabaseObserver() {
        self.worker.observer = nil
    }
    
    func loadUserProfileData(userID:String) {
        self.showActivityIndicator()
        worker.getUserDataWith(userID: userID) { (user) in
            DispatchQueue.main.async {
                self.user = user
                self.dishCollectionViewAdapter.userData = user
                self.dishCollectionViewAdapter.selectedIndexForProfile = .cooked
                self.hideActivityIndicator()
                self.dishCollectionViewAdapter.collectionView?.reloadData()
            }
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
        
        worker.getSavedDishesCountFor(userID: userID) { (count) in
            print(count)
            self.dishCollectionViewAdapter.savedDishDataCount = count
        }
    }
    
    private func loadCountsForAllSections() {
        guard let user = self.user else { return }
        
        self.worker.getCookedDishesForUser(userID: user.id, { (cookedDishes) in
            self.dishCollectionViewAdapter.cookedDishData = cookedDishes
        })
        
        self.worker.getBoughtDishesForUser(userID: user.id, { (boughtDishes) in
            self.dishCollectionViewAdapter.boughtDishData = boughtDishes
        })
        
        self.worker.getActivity(for: user.id, completion: { (newsFeedList) in
            self.dishCollectionViewAdapter.activityData = newsFeedList
        })
    }
    
    func loadDishCollectionViewForIndex(_ index:SelectedIndexForProfile) {
        guard let user = self.user else {return}
        
        self.showActivityIndicator()
        
        switch index {
        case .cooked:
            self.worker.getCookedDishesForUser(userID: user.id, { (cookedDishes) in
                self.dishCollectionViewAdapter.selectedIndexForProfile = .cooked
                self.dishCollectionViewAdapter.cookedDishData = cookedDishes
            })

        case .bought:
            self.worker.getBoughtDishesForUser(userID: user.id, { (boughtDishes) in
                self.dishCollectionViewAdapter.selectedIndexForProfile = .bought
                self.dishCollectionViewAdapter.boughtDishData = boughtDishes
                
            })

        case .activity:
            self.worker.getActivity(for: user.id, completion: { (newsFeedList) in
                self.dishCollectionViewAdapter.selectedIndexForProfile = .activity
                self.dishCollectionViewAdapter.activityData = newsFeedList
            })
        }
        self.hideActivityIndicator()
        
    }
    
    func toggleFollow(userID: String, shouldFollow: Bool) {
        guard let currentUser = DatabaseGateway.sharedInstance.getLoggedInUser() else {return}
        worker.toggleFollow(targetUser: userID, currentUser: currentUser.id, targetUserName: self.user!.name, currentUserName: currentUser.name , shouldFollow: shouldFollow) { (success) in
            if success {
                print("follow toggled")
            }
        }
    }
    
    //MARK: - DishesCollectionViewAdapterDelegate
    func openDishPageWith(dishID:String) {
        
        output.openDishPageWith(dishID: dishID)
        
    }
    
    func openFavouriteDishes() {
        output.openFavouriteDishes()
    }
    
    func openFollowers(followers:Bool, userList:[MFUser]) {
        output.openFollowers(followers: followers, userList:userList)
    }
    
}
