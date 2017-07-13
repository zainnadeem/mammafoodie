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

    func getFollowersForUser(userID:String, frequency:DatabaseRetrievalFrequency = .single, _ completion:@escaping (_ dishes:[MFUser]?)->Void){
        
        followersResponseCounter = 0
        
        DatabaseGateway.sharedInstance.getFollowersForUser(userID: userID, frequency: frequency) { (followers) in
            
            
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
    
    
    func getFollowingForUser(userID:String, frequency:DatabaseRetrievalFrequency = .single, _ completion:@escaping (_ dishes:[MFUser]?)->Void){
        
        followingResponseCounter = 0
        
        DatabaseGateway.sharedInstance.getFollowingForUser(userID: userID, frequency:  frequency) { (following) in
            
            
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
    
    
    func toggleFollow(targetUser:String, currentUser:String, targetUserName:String, currentUserName:String, shouldFollow:Bool, _ completion:@escaping (_ success:Bool)->()){
        
        var urlString = ""
        
        if shouldFollow {
            urlString = "https://us-central1-mammafoodie-baf82.cloudfunctions.net/followUser?firstUserId=\(currentUser)&secondUserId=\(targetUser)&firstUserFullname=\(currentUserName)&secondUserFullname=\(targetUserName)"
        } else {
            urlString = "https://us-central1-mammafoodie-baf82.cloudfunctions.net/unfollowUser?firstUserId=\(currentUser)&secondUserId=\(targetUser)"
        }
        
      
        guard let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { print("Error encoding the url string"); return }

        let url = URL(string: encodedString)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let config = URLSessionConfiguration.default

        let session = URLSession(configuration: config)
        session.dataTask(with: request) { (data, response, error) in
            guard let response = response as? HTTPURLResponse else { print("there was an error");
                
                completion(false)
                return }
            
            if response.statusCode != 200 {
                print("There was an error with your request")
                completion(false)
            }
            if let responseDict = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                if let responseDict = responseDict {
                    completion(true)
                }
                else {
                    completion(false)
                }
            } else {
                completion(false)
            }
            }.resume()
        
    }
    
}
