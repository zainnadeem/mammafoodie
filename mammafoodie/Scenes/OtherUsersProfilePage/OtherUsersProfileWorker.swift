import UIKit

class OtherUsersProfileWorker {
    
    var responseCounterCooked = 0
    
    var responseCounterBought = 0
    
    var followersResponseCounter = 0
    
    var followingResponseCounter = 0
    
    var responseCounterSaved = 0
    
    var observer: DatabaseConnectionObserver?
    
    // MARK: - Business Logic
    
    func getUserDataWith(userID:String, completion: @escaping (MFUser?)->Void){
        self.observer = DatabaseGateway.sharedInstance.getUserWith(userID: userID, frequency: .realtime) { (user) in
            completion(user)
        }
    }
    
    func stopObserver() {
        self.observer?.stop()
        self.observer = nil
    }
    
    func getDishWith(dishID:String, completion: @escaping (MFDish?)->Void) {
        _ = DatabaseGateway.sharedInstance.getDishWith(dishID: dishID) { (dish) in
            completion(dish)
        }
        
    }
    
    func getActivity(for userId:String, completion: @escaping ([MFNewsFeed]) -> Void) {
        DatabaseGateway.sharedInstance.getNewsFeed(by: userId, completion)
    }
    
    func getCookedDishesForUser(userID:String, _ completion:@escaping ([MFDish])->Void) {
        DatabaseGateway.sharedInstance.getCookedDishesForUser(userID: userID) { (dishDataDictionary) in
            guard dishDataDictionary != nil else {
                completion([])
                return
            }
            var dishes = [MFDish]()
            let group = DispatchGroup()
            for dishID in dishDataDictionary!.keys {
                group.enter()
                _ = DatabaseGateway.sharedInstance.getDishWith(dishID: dishID, { (dish) in
                    if let dish = dish {
                        dishes.append(dish)
                    }
                    group.leave()
                })
            }
            group.notify(queue: .main, execute: {
                completion(dishes)
            })
        }
    }
    
    func getBoughtDishesForUser(userID:String, _ completion:@escaping (_ dishes:[MFDish])->Void) {
        DatabaseGateway.sharedInstance.getBoughtDishesForUser(userID: userID) { (dishDataDictionary) in
            guard let dishDataDictionary = dishDataDictionary else {
                completion([])
                return
            }
            var dishes = [MFDish]()
            let group = DispatchGroup()
            for dishID in dishDataDictionary.keys {
                group.enter()
                _ = DatabaseGateway.sharedInstance.getDishWith(dishID: dishID, { (dish) in
                    if let dish = dish {
                        dishes.append(dish)
                    }
                    group.leave()
                })
            }
            group.notify(queue: .main, execute: {
                completion(dishes)
            })
            
        }
    }
    
    func getSavedDishesForUser(userID:String, _ completion:@escaping (_ dishes:[MFDish])->Void) {
        responseCounterSaved = 0
        DatabaseGateway.sharedInstance.getSavedDishesForUser(userID: userID) { (dishes) in
            completion(dishes)
        }
    }
    
    func getSavedDishesCountFor(userID:String, _ completion:@escaping (Int)->()) {
        DatabaseGateway.sharedInstance.getSavedDishesForUser(userID: userID) { (dishDataDictionary) in
            completion(dishDataDictionary.count)
        }
        
    }
    
    func getFollowersForUser(userID:String, frequency:DatabaseRetrievalFrequency = .single, _ completion:@escaping ([MFUser])->Void) -> DatabaseConnectionObserver? {
        return DatabaseGateway.sharedInstance.getFollowersForUser(userID: userID, frequency: frequency) { (followers) in
            guard followers != nil else {
                completion([])
                return
            }
            var users = [MFUser]()
            let group = DispatchGroup()
            for userID in followers!.keys {
                group.enter()
                _ = DatabaseGateway.sharedInstance.getUserWith(userID: userID){ (user) in
                    if user != nil {
                        users.append(user!)
                    }
                    group.leave()
                }
            }
            group.notify(queue: .main, execute: {
                completion(users)
            })
        }
        
    }
    
    func getFollowingForUser(userID:String, frequency:DatabaseRetrievalFrequency = .single, _ completion: (([MFUser])->Void)?) -> DatabaseConnectionObserver? {
        return DatabaseGateway.sharedInstance.getFollowingForUser(userID: userID, frequency:  frequency) { (following) in
            var users = [MFUser]()
            guard following != nil else {
                completion?(users)
                return
            }
            let group = DispatchGroup()
            for userID in following!.keys {
                group.enter()
                _ = DatabaseGateway.sharedInstance.getUserWith(userID: userID){ (user) in
                    if let user = user {
                        users.append(user)
                    }
                    group.leave()
                }
            }
            group.notify(queue: .main, execute: {
                completion?(users)
                return
            })
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
                return
            }
            if response.statusCode != 200 {
                print("There was an error with your request")
                completion(false)
            }
            
            if let responseDict = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                if responseDict != nil {
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
