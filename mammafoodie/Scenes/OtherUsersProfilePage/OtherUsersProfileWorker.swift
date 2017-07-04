import UIKit

class OtherUsersProfileWorker {
    
    var responseCounterCooked = 0
    
    var responseCounterBought = 0
    
    var followersResponseCounter = 0
    
    var followingResponseCounter = 0
    
    // MARK: - Business Logic
    
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
    
    
    func getCookedDishesForUser(userID:String, _ completion:@escaping (_ dishes:[MFDish]?)->Void){
        
        responseCounterCooked = 0
        
        DatabaseGateway.sharedInstance.getCookedDishesForUser(userID: userID) { (dishDataDictionary) in
            
             print(dishDataDictionary)
            
            guard dishDataDictionary != nil else {return}
            
            var dishes = [MFDish]()
            
            for dishID in dishDataDictionary!.keys {
                
                 DatabaseGateway.sharedInstance.getDishWith(dishID: dishID, { (dish) in
                    print(dish?.name)
                    self.responseCounterCooked += 1
                    
                    if dish != nil {
                        dishes.append(dish!)
                    }
                    
                    if self.responseCounterCooked == dishDataDictionary!.keys.count{
                        completion(dishes)
                    }
                    
                })
            }
            
        }
    }
    
    func getBoughtDishesForUser(userID:String, _ completion:@escaping (_ dishes:[MFDish]?)->Void){
        
        responseCounterBought = 0
        
        DatabaseGateway.sharedInstance.getBoughtDishesForUser(userID: userID) { (dishDataDictionary) in
            
            print(dishDataDictionary)
            
            guard dishDataDictionary != nil else {return}
            
            var dishes = [MFDish]()
            
            for dishID in dishDataDictionary!.keys {
                
                DatabaseGateway.sharedInstance.getDishWith(dishID: dishID, { (dish) in
                    self.responseCounterBought += 1
                    
                    if dish != nil {
                        dishes.append(dish!)
                    }
                    
                    if self.responseCounterBought == dishDataDictionary!.keys.count{
                        completion(dishes)
                    }
                })
            }
            
        }
    }

    func getFollowersForUser(userID:String, _ completion:@escaping (_ dishes:[MFUser]?)->Void){
        
        followersResponseCounter = 0
        
        DatabaseGateway.sharedInstance.getFollowersForUser(userID: userID) { (followers) in
            
            
            guard followers != nil else {return}
            
            var users = [MFUser]()
            
            for userID in followers!.keys {
                
                
                DatabaseGateway.sharedInstance.getUserWith(userID: userID){ (user) in
                    
                    self.followersResponseCounter += 1
                    if user != nil {
                        users.append(user!)
                    }
                    
                    if self.followersResponseCounter == followers!.keys.count{
                        completion(users)
                    }
                    
                }
            }
            
        }
    }
    
    
    func getFollowingForUser(userID:String, _ completion:@escaping (_ dishes:[MFUser]?)->Void){
        
        followingResponseCounter = 0
        
        DatabaseGateway.sharedInstance.getFollowingForUser(userID: userID) { (following) in
            
            
            guard following != nil else {return}
            
            var users = [MFUser]()
            
            for userID in following!.keys {
                
                
                DatabaseGateway.sharedInstance.getUserWith(userID: userID){ (user) in
                    
                    self.followingResponseCounter += 1
                    if user != nil {
                        users.append(user!)
                    }
                    
                    if self.followingResponseCounter == following!.keys.count{
                        completion(users)
                    }
                    
                }
            }
            
        }
    }
    
}
