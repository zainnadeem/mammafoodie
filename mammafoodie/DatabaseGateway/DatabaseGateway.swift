import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

import Alamofire

enum FirebaseReference: String {
    
    case media = "Media"
    case liveVideos = "LiveVideos"
    case dishRequests = "DishRequests"
    case dishes = "Dishes"
    case dishComments = "DishComments"
    case conversations = "Conversations"
    case messages = "Messages"
    case orders = "Orders"
    case paymentDetails = "PaymentDetails"
    case comments = "Comments"
    case newsFeedComments = "NewsFeedComments"
    case notifications = "Notifications"
    case newsFeed = "NewsFeed"
    case newsFeedAll = "NewsFeed_All"
    case liveVideoGatewayAccountDetails = "LiveVideoGatewayAccountDetails"
    case users = "Users"
    
    case stripeCustomers = "stripe_customers"
    //    case dishComments = "DishComments"
    case savedDishes = "SavedDishes"
    case likedDishes = "LikedDishes"
    
    //    case dishBoughtBy = "DishBoughtBy"
    case cookedDishes = "CookedDishes"
    case boughtDishes = "BoughtDishes"
    case followers = "UserFollowers"
    case following = "UserFollowing"
    case userNewsFeed = "UserNewsFeed"
    case cuisines = "Cuisines"
    case dishLikes = "DishLikes"
    case notificationsForUser = "NotificationsForUser"
    case userAddress = "UserAddress"
    case address = "Address"
    case userConversations = "UserConversations"
    //case conversationLookup = "ConversationLookup"
    
    // temporary class for LiveVideoDemo. We will need to delete this later on
    //    case tempLiveVideosStreamNames = "TempLiveVideosStreamNames"
    
    var classReference: DatabaseReference {
        return Database.database().reference().child(self.rawValue)
    }
    
    func generateAutoID() -> String {
        return self.classReference.childByAutoId().key
    }
    
    func get(with id: String) -> DatabaseReference {
        return self.classReference.child(id) // root/className/id
    }
    
    func dateConvertion(with date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dateString = dateFormatter.string(from:date)
        return dateString
    }
    
    func getImagePath(with id: String) -> URL? {
        let classPath: String = self.rawValue.lowercased()
        let path: String = "https://firebasestorage.googleapis.com/v0/b/mammafoodie-baf82.appspot.com/o/\(classPath)%2F\(id).jpg?alt=media"
        return URL(string: path)
    }
    
}

struct DatabaseConnectionObserver {
    var observerId: UInt = 0
    var databaseReference: DatabaseReference? = nil
    
    init() {
    }
    
    func stop() {
        print("Stopped")
        self.databaseReference?.removeObserver(withHandle: self.observerId)
    }
}

enum DatabaseRetrievalFrequency {
    case single
    case realtime
}

class DatabaseGateway {
    
    static let sharedInstance = DatabaseGateway()
    
    typealias FirebaseObserverSuccessClosure = ((DataSnapshot)->Void)
    typealias FirebaseObserverCancelClosure = ((Error)->Void)
    typealias FirebaseDictionary = [String:AnyObject]
    
    // This is to not allow initialization by anyone else other than this class itself. Use sharedInstace for every operation on Firebase
    private init() {
        print("Configuring FirebaseApp ----------------------- START")
        FirebaseApp.configure()
        print("Configuring FirebaseApp ----------------------- END")
    }
}

// MARK: - Live streams
extension DatabaseGateway {
    
    //    func getLiveStream(with id: String, _ completion: @escaping ((MFDish?)->Void)) {
    //        FirebaseReference.tempLiveVideosStreamNames.get(with: id).observeSingleEvent(of: .value, with: { (streamNameDataSnapshot) in
    //            guard let liveStreamName = streamNameDataSnapshot.value as? String else {
    //                completion(nil)
    //                return
    //            }
    //            let liveStream: MFDish? = self.createLiveStreamModel(from: liveStreamName, id: id)
    //            completion(liveStream)
    //        }) { (error) in
    //            print(error)
    //            completion(nil)
    //        }
    //    }
    
    //    func getLiveStreams(frequency: DatabaseRetrievalFrequency = .single, _ completion: @escaping ([MFDish])->Void) {
    //
    //        let successClosure: FirebaseObserverSuccessClosure = { (streamNamesDataSnapshot) in
    //            guard let rawLiveStreams: FirebaseDictionary = streamNamesDataSnapshot.value as? FirebaseDictionary else {
    //                completion([])
    //                return
    //            }
    //            var liveStreams: [MFDish] = []
    //            for rawLiveStreamKey in rawLiveStreams.keys {
    //                guard let liveStreamName = rawLiveStreams[rawLiveStreamKey] as? String else {
    //                    continue
    //                }
    //                guard let liveStream: MFDish = self.createLiveStreamModel(from: liveStreamName, id: rawLiveStreamKey) else {
    //                    continue
    //                }
    //                liveStreams.append(liveStream)
    //            }
    //            completion(liveStreams)
    //        }
    //
    //        let cancelClosure: FirebaseObserverCancelClosure = { (error) in
    //            print(error)
    //            completion([])
    //        }
    //
    //        switch frequency {
    //        case .realtime:
    //            FirebaseReference.tempLiveVideosStreamNames.classReference.observe(.value, with: successClosure, withCancel: cancelClosure)
    //        default:
    //            FirebaseReference.tempLiveVideosStreamNames.classReference.observeSingleEvent(of: .value, with: successClosure, withCancel: cancelClosure)
    //        }
    //    }
    
    //    func createLiveStreamModel(from streamName: String, id: String) -> MFDish? {
    //        let liveStream: MFDish = MFDish()
    //        liveStream.id = id
    //        //        liveStream.contentId = streamName
    //        return liveStream
    //    }
    
    //    func publishNewLiveStream(with name: String, _ completion: @escaping ((MFDish?)->Void)) {
    //        let liveStream: MFDish = MFDish()
    //        liveStream.id = FirebaseReference.tempLiveVideosStreamNames.generateAutoID()
    //        //        liveStream.contentId = name
    //        let rawLiveStream: FirebaseDictionary = MFModelsToFirebaseDictionaryConverter.dictionary(from: liveStream)
    //
    //        FirebaseReference.tempLiveVideosStreamNames.classReference.updateChildValues(rawLiveStream, withCompletionBlock: { (error, databaseReference) in
    //            if error != nil {
    //                print(error!)
    //            } else {
    //
    //            }
    //            completion(liveStream)
    //        })
    //    }
    
    func endLiveStream(_ liveStream: MFDish, _ completion: @escaping (()->Void)) {
        let rawLiveStream: FirebaseDictionary = MFModelsToFirebaseDictionaryConverter.dictionary(from: liveStream)
        FirebaseReference.dishes.get(with: liveStream.id).updateChildValues(rawLiveStream) { (error, databaseReference) in
            completion()
        }
    }
}

// MARK: - LiveVideoGatewayAccountDetails
extension DatabaseGateway {
    
    func getLiveVideoGatewayAccountDetails(frequency: DatabaseRetrievalFrequency = .single, _ completion: @escaping (MFLiveVideoGatewayAccountDetails?)->Void) -> DatabaseConnectionObserver? {
        
        let successClosure: FirebaseObserverSuccessClosure  = { (accountDetailsDataSnapshot) in
            guard let rawAccountDetails: FirebaseDictionary = accountDetailsDataSnapshot.value as? FirebaseDictionary else {
                completion(nil)
                return
            }
            let accountDetails: MFLiveVideoGatewayAccountDetails? = self.createLiveVideoGatewayAccountDetailsModel(from: rawAccountDetails)
            completion(accountDetails)
        }
        
        let cancelClosure: FirebaseObserverCancelClosure = { (error) in
            print(error)
            completion(nil)
        }
        
        switch frequency {
        case .realtime:
            var observer: DatabaseConnectionObserver = DatabaseConnectionObserver()
            observer.databaseReference = FirebaseReference.liveVideoGatewayAccountDetails.classReference
            observer.observerId = observer.databaseReference!.observe(.value, with: successClosure, withCancel: cancelClosure)
            return observer
        default:
            FirebaseReference.liveVideoGatewayAccountDetails.classReference.observeSingleEvent(of: .value, with: successClosure, withCancel: cancelClosure)
        }
        return nil
    }
    
    func createLiveVideoGatewayAccountDetailsModel(from rawData: FirebaseDictionary) -> MFLiveVideoGatewayAccountDetails? {
        var accountDetails: MFLiveVideoGatewayAccountDetails = MFLiveVideoGatewayAccountDetails()
        guard let hostIPAddress: String = rawData["hostIPAddress"] as? String else {
            return nil
        }
        guard let port: Int32 = rawData["port"] as? Int32 else {
            return nil
        }
        guard let sdkKey: String = rawData["sdkKey"] as? String else {
            return nil
        }
        guard let serviceProviderName: String = rawData["name"] as? String else {
            return nil
        }
        
        accountDetails.host = hostIPAddress
        accountDetails.port = port
        accountDetails.sdkKey = sdkKey
        accountDetails.serviceProviderName = serviceProviderName
        
        return accountDetails
    }
}




// MARK: - Messages and Conversation
extension DatabaseGateway {
    
    func createMessage(with model: MFMessage, conversationID:String, _ completion: @escaping ((_ status:Bool)->Void)) {
        var newMessage = model
        let newMessageID = FirebaseReference.messages.generateAutoID()
        newMessage.id = newMessageID
        let rawMessage: FirebaseDictionary = MFModelsToFirebaseDictionaryConverter.dictionary(from: newMessage)
        FirebaseReference.messages.classReference.child(conversationID).child(newMessageID).updateChildValues(rawMessage) { (error, databaseReference) in
            if error != nil {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func createConversation(createdAt:String, user1:String, user2:String, user1Name:String, user2Name:String, _ completion: @escaping ((_ status:Bool)->Void)){
        let newConversationID = FirebaseReference.conversations.generateAutoID()
        let metaData = ["id": newConversationID,"createdAt":createdAt, "user1":user1, "user2":user2, "user1Name":user1Name, "user2Name":user2Name]
        let childUpdates = [
            "\(FirebaseReference.conversations.rawValue)/\(newConversationID)/":metaData,
            "/\(FirebaseReference.userConversations.rawValue)/\(user1)/\(newConversationID)/":true,
            "/\(FirebaseReference.userConversations.rawValue)/\(user2)/\(newConversationID)/":true
            // "\(FirebaseReference.conversationLookup.rawValue)/\(user1)/":["user2":user2,"conversationID":newConversationID]
            ] as [AnyHashable : Any]
        //        print(childUpdates)
        
        let databaseRef = Database.database().reference()
        databaseRef.updateChildValues(childUpdates) { (error, databaseReference) in
            if error != nil{
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    
    func getConversations(forUser userID:String, _ completion : @escaping (MFConversation?)->())->DatabaseConnectionObserver?{
        var observer = DatabaseConnectionObserver()
        observer.databaseReference = FirebaseReference.userConversations.classReference
        observer.observerId =  FirebaseReference.userConversations.classReference.child(userID).observe(.childAdded, with: { (conversationData) in
            //print(messageData)
            print(conversationData.key)
            self.getConversation(with: conversationData.key, { (conversationDictionary) in
                if conversationDictionary != nil {
                    let conversation = MFConversation(from: conversationDictionary!)
                    completion(conversation)
                }
            })
        }) { (error) in
            print(error.localizedDescription)
        }
        
        return observer
        
    }
    
    func getConversation(with conversationID:String, _ completion:@escaping (FirebaseDictionary?)->()) {
        FirebaseReference.conversations.classReference.child(conversationID).observeSingleEvent(of: .value, with: { (conversation) in
            guard let conversationDictionary = conversation.value as? FirebaseDictionary else {
                completion(nil)
                return
            }
            completion(conversationDictionary)
        })
    }
    
    func getMessages(forConversation conversationID:String, _ completion:@escaping (MFMessage?)->()) -> DatabaseConnectionObserver? {
        var observer = DatabaseConnectionObserver()
        observer.databaseReference = FirebaseReference.messages.classReference
        observer.observerId =  FirebaseReference.messages.classReference.child(conversationID).observe(.childAdded, with: { (messageData) in
            //print(messageData)
            guard let messagesDictionary = messageData.value as? FirebaseDictionary else {
                completion(nil)
                return
            }
            let message = MFMessage(from: messagesDictionary)
            completion(message)
        }) { (error) in
            print(error.localizedDescription)
        }
        
        return observer
    }
    
}


//MARK: - User
extension DatabaseGateway {
    
    func createUserEntity(with model: MFUser, _ completion: @escaping ((_ errorMessage:String?)->Void)) {
        
        let rawUsers: FirebaseDictionary = MFModelsToFirebaseDictionaryConverter.dictionary(from: model)
        
        FirebaseReference.users.classReference.child(model.id).updateChildValues(rawUsers) { (error, databaseReference) in
            completion(error?.localizedDescription)
        }
    }
    
    func updateUserEntity(with model:MFUser, _ completion: @escaping ((String?)->Void)) {
        
        let rawUserData:FirebaseDictionary = MFModelsToFirebaseDictionaryConverter.dictionary(from: model)
        let _ :String = "\(model.id)"
        FirebaseReference.users.classReference.child(model.id).updateChildValues(rawUserData) { (error, databaseReference) in
            completion(error?.localizedDescription)
        }
    }
    
    func getUserWith(userID:String, _ completion: @escaping ((_ user:MFUser?)->Void)){
        
        FirebaseReference.users.classReference.child(userID).observeSingleEvent(of: .value, with: { (userDataSnapshot) in
            guard let userData = userDataSnapshot.value as? FirebaseDictionary else {
                completion(nil)
                return
            }
            
            let user:MFUser = MFUser(from: userData)
            user.id = userID
            
            completion(user)
        }) { (error) in
            print(error)
            completion(nil)
        }
    }
    
    func getLoggedInUser() -> MFUser? {
        if let currentUser = Auth.auth().currentUser {
            let user: MFUser = MFUser()
            user.id = currentUser.uid
            user.name = currentUser.displayName
            return user
        }
        return nil
    }
    
    func setDeviceToken(_ token: String, for userId: String, _ completion: @escaping ((Error?)->Void)) {
        let deviceToken = ["deviceToken":token] as FirebaseDictionary
        FirebaseReference.users.get(with: userId).updateChildValues(deviceToken) { (error, databaseRef) in
            completion(error)
        }
    }
}

//MARK: - Dish
extension DatabaseGateway {
    
    func getAllDish(_ completion : @escaping ([MFDish]) -> Void) {
        FirebaseReference.dishes.classReference.observeSingleEvent(of: .value, with: { (snapshot) in
            var allDishes = [MFDish]()
            if let dishes = snapshot.value as? FirebaseDictionary {
                for (_, value) in dishes {
                    if let dict = value as? FirebaseDictionary {
                        let dish = MFDish.init(from: dict)
                        allDishes.append(dish)
                    }
                }
            }
            completion(allDishes)
        })
    }
    
    func getDishViewers(id: String, _ completion: @escaping (_ numberOfViewers: UInt)->Void) -> DatabaseConnectionObserver {
        let databaseReference: DatabaseReference = FirebaseReference.dishes.classReference.child(id)
        var observer: DatabaseConnectionObserver = DatabaseConnectionObserver()
        observer.databaseReference = databaseReference
        observer.observerId = databaseReference.observe(DataEventType.childChanged, with: { (snapshot) in
            if snapshot.key == "numberOfViewers" {
                let count = snapshot.value as? UInt ?? 0
                print(count)
                completion(count)
            }
        }) { (error) in
            print("error: \(error)")
            print("")
        }
        return observer
    }
    
    func getDishWith(dishID:String, frequency:DatabaseRetrievalFrequency = .single, _ completion:@escaping (_ dish:MFDish?)->Void) -> DatabaseConnectionObserver?{
        print(dishID)
        
        let successClosure:FirebaseObserverSuccessClosure = { (userDataSnapshot) in
            
            guard let dishData = userDataSnapshot.value as? FirebaseDictionary else {
                completion(nil)
                return
            }
            
            let dish:MFDish = self.createDish(from: dishData)
            completion(dish)
        }
        
        let cancelClosure:FirebaseObserverCancelClosure = { (error) in
            print(error)
            completion(nil)
        }
        
        
        let databaseReference: DatabaseReference = FirebaseReference.dishes.classReference
        let databaseQuery: DatabaseQuery = databaseReference.child(dishID)
        
        switch frequency{
        case .single:
            
            databaseReference.child(dishID).observeSingleEvent(of: .value, with: successClosure, withCancel: cancelClosure)
            
        case .realtime:
            
            var observer: DatabaseConnectionObserver = DatabaseConnectionObserver()
            observer.databaseReference = databaseReference
            observer.observerId = databaseQuery.observe(.value, with: successClosure, withCancel: cancelClosure)
            
            return observer
            
        }
        
        return nil
        
    }
    
    
    func getCookedDishesForUser(userID:String, _ completion:@escaping (_ dishes:[String:AnyObject]?)->Void){
        
        FirebaseReference.cookedDishes.classReference.child(userID).observeSingleEvent(of: .value, with: { (dishSnapshot) in
            
            guard let dishData = dishSnapshot.value as? FirebaseDictionary else {
                completion(nil)
                return
            }
            
            completion(dishData)
        })
    }
    
    
    func getBoughtDishesForUser(userID:String, _ completion:@escaping (_ dishes:[String:AnyObject]?)->Void){
        
        FirebaseReference.boughtDishes.classReference.child(userID).observeSingleEvent(of: .value, with: { (dishSnapshot) in
            
            guard let dishData = dishSnapshot.value as? FirebaseDictionary else {
                completion(nil)
                return
            }
            
            completion(dishData)
        })
    }
    
    
    
    func updateDish(with model:MFDish, _ completion: @escaping ((_ errorMessage:String?)->Void)){
        
        let userProfileData:FirebaseDictionary = MFModelsToFirebaseDictionaryConverter.dictionary(from: model)
        let _ :String = "\(model.id)"
        FirebaseReference.users.classReference.child(model.id).updateChildValues(userProfileData) { (error, databaseReference) in
            
            completion(error?.localizedDescription)
            
        }
    }
    
    
    func getDishComments(dishID: String, _ completion:@escaping (_ comments:[MFComment]?) -> Void){
        
        FirebaseReference.dishComments.classReference.child(dishID).observeSingleEvent(of: .value, with: {(commentsDataSnapshot) in
            guard let commentsData = commentsDataSnapshot.value as? FirebaseDictionary else {
                
                completion(nil)
                return
                
            }
            var comments: [MFComment] = []
            
            for rawComment in commentsData {
                let newComment = MFComment(from: rawComment.value as! [String : AnyObject])
                comments.append(newComment)
            }
            
            completion(comments)
            
        }) {(error) in
            print(error)
            completion(nil)
        }
    }
    
    
    //    func getUsersWhoBoughtTheDish(dishID:String, _ completion:@escaping (_ users:[String:AnyObject]?) -> Void){
    //
    //        FirebaseReference.dishBoughtBy.classReference.child(dishID).observeSingleEvent(of: .value, with: { (userDataSnapshot) in
    //            guard let userData = userDataSnapshot.value as? FirebaseDictionary else {
    //                completion(nil)
    //                return
    //            }
    //
    //            completion(userData)
    //        }) { (error) in
    //            print(error)
    //            completion(nil)
    //        }
    //
    //    }
    
    func getDishLike(dishID:String, _ completion:@escaping (_ likeCount:Int?)->Void){
        
        let successClosure: FirebaseObserverSuccessClosure = { (dishLikeDataSnapshot) in
            guard let dishData = dishLikeDataSnapshot.value as? FirebaseDictionary else {
                completion(0)
                return
            }
            completion(dishData.count)
        }
        
        let cancelClosure: FirebaseObserverCancelClosure = { (error) in
            print(error)
            completion(0)
        }
        
        FirebaseReference.dishLikes.classReference.child(dishID).observe(.value, with: successClosure, withCancel: cancelClosure)
    }
    
    func getLikeStatus(dishID:String,user_Id:String , _ completion:@escaping (_ likeStatus:Bool?)->Void){
        FirebaseReference.dishLikes.classReference.child(dishID).observeSingleEvent(of: .value, with: { (dishLikeDataSnapshot) in
            guard let dishData = dishLikeDataSnapshot.value as? FirebaseDictionary else {
                completion(false)
                return
            }
            guard dishData[user_Id] != nil else {
                completion(false)
                return
            }
            completion(true)
        }) { (error) in
            print(error)
            completion(false)
        }
        
    }
    
}

//Mark: - Saved Dish

extension DatabaseGateway {
    
    //    func checkSavedDishes(userId: String, dishId: String, _ completion: @escaping (_ status:Bool?) -> Void){
    //        FirebaseReference.savedDishes.classReference.child(userId).observeSingleEvent(of: .value, with: {(dishSnapshot) in
    //
    //            guard let dishData = dishSnapshot.value as? FirebaseDictionary else {
    //
    //                completion(nil)
    //                return
    //            }
    //
    //            if dishData[dishId] != nil {
    //                completion(true)
    //            }else{
    //                completion(false)
    //            }
    //
    //        })
    //    }
    //
    
    func toggleDishBookmark(userID:String, dishID:String, shouldBookmark:Bool, _ completion:@escaping (_ success:Bool)->()){
        
        if shouldBookmark {
            FirebaseReference.savedDishes.classReference.child(userID).updateChildValues([dishID:true])
            
        } else {
            FirebaseReference.savedDishes.classReference.child(userID).child(dishID).removeValue()
        }
        
    }
    
    func checkIfDishBookMarked(dishID:String, userID:String, _ completion:@escaping (_ bookmarked:Bool)->()){
        FirebaseReference.savedDishes.classReference.child(userID).observeSingleEvent(of: .value, with: {(dishSnapshot) in
            
            guard let dishData = dishSnapshot.value as? FirebaseDictionary else {
                
                completion(false)
                return
            }
            
            if dishData[dishID] != nil {
                completion(true)
            }else{
                completion(false)
            }
            
        })
        
    }
    
    
    func getSavedDishesForUser(userID:String, _ completion:@escaping ([String:AnyObject]?)->()) {
        
        FirebaseReference.savedDishes.classReference.child(userID).observeSingleEvent(of: .value, with: {(dishSnapshot) in
            
            guard let dishData = dishSnapshot.value as? FirebaseDictionary else {
                
                completion([:])
                return
            }
            
            completion(dishData)
            
        })
    }
    
}

//Mark: - Liked Dish

extension DatabaseGateway {
    
    func checkLikedDishes(userId: String, dishId: String, _ completion: @escaping (_ status:Bool?) -> Void){
        
        print(userId)
        print(dishId)
        
        FirebaseReference.dishLikes.classReference.child(dishId).observeSingleEvent(of: .value, with: {(dishSnapshot) in
            guard let userData = dishSnapshot.value as? FirebaseDictionary else {
                print(dishSnapshot.value ?? "")
                completion(nil)
                return
            }
            
            if userData[userId] != nil {
                completion(true)
            }else{
                completion(false)
            }
            
        })
    }
}

//MARK: - Media
extension  DatabaseGateway {
    
    func getMediaWith(mediaID:String, _ completion:@escaping (_ dish:MFDish?)->Void ){
        
        FirebaseReference.media.classReference.child(mediaID).observeSingleEvent(of: .value, with: { (userDataSnapshot) in
            guard let mediaData = userDataSnapshot.value as? FirebaseDictionary else {
                completion(nil)
                return
            }
            let media:MFDish = MFDish(from: mediaData)
            
            completion(media)
        }) { (error) in
            print(error)
            completion(nil)
        }
    }
}

// MARK: - News Feed
extension DatabaseGateway {
    
    func getNewsFeed(for userId: String, _ completion: @escaping (([MFNewsFeed]) -> Void)) {
        let successClosure: FirebaseObserverSuccessClosure  = { (snapshot) in
            guard let rawNewsFeed = snapshot.value as? [String: Double] else {
                completion([])
                return
            }
            var feeds = [MFNewsFeed]()
            let requestGroup = DispatchGroup.init()
            for (id, _) in rawNewsFeed.sorted(by: { ($0.value > $1.value)}) {
                requestGroup.enter()
                self.getNewsFeed(with: id, { (feed) in
                    if let f = feed {
                        feeds.append(f)
                    }
                    requestGroup.leave()
                })
            }
            requestGroup.notify(queue: .main, execute: {
                completion(feeds)
            })
            
        }
        
        let cancelClosure: FirebaseObserverCancelClosure = { (error) in
            print(error)
            DispatchQueue.main.async {
                completion([])
            }
        }
        
        FirebaseReference.newsFeed.classReference.child(userId).observe(.value, with: successClosure, withCancel: cancelClosure)
    }
    
    func getNewsFeed(with newsFeedID: String, _ completion: @escaping ((MFNewsFeed?) -> Void)) {
        FirebaseReference.newsFeedAll.classReference.child(newsFeedID).observeSingleEvent(of: .value, with: { (snapshot) in
            DispatchQueue.main.async {
                if let data = snapshot.value as? [String: AnyObject] {
                    completion(MFNewsFeed.init(from: data))
                } else {
                    completion(nil)
                }
            }
        })
    }
    
    func save(_ newsFeed: MFNewsFeed, completion: @escaping ((Error?) -> Void)) {
        FirebaseReference.newsFeedAll.classReference.child(newsFeed.id).updateChildValues(MFModelsToFirebaseDictionaryConverter.dictionary(from: newsFeed)) { (error, ref) in
            completion(error)
        }
    }
    
    func createNewsFeedModel(from raw: FirebaseDictionary) -> MFNewsFeed {
        let feed: MFNewsFeed = MFNewsFeed.init(from: raw)
        return feed
    }
}

// MARK: - Media
extension DatabaseGateway {
    func getCuisines(_ completion : @escaping ([MFCuisine]) -> Void) {
        FirebaseReference.cuisines.classReference.observeSingleEvent(of: .value, with: { (snapshot) in
            var allCuisins = [MFCuisine]()
            if let rawCuisines = snapshot.value as? FirebaseDictionary {
                for (_, value) in rawCuisines {
                    if let dict = value as? FirebaseDictionary {
                        let cuisine = MFCuisine.init(with: dict)
                        allCuisins.append(cuisine)
                    }
                }
            }
            completion(allCuisins)
        })
    }
}

// MARK: - Dish
extension DatabaseGateway {
    
    func getLiveVideos(_ completion: @escaping ((_ liveVideos: [MFDish])->Void)) -> DatabaseConnectionObserver? {
        return self.getDishes(type: MFDishMediaType.liveVideo, frequency: .realtime) { (dishes) in
            let filteredDishes: [MFDish] = dishes.filter({ (dish) -> Bool in
                if dish.endTimestamp == nil {
                    return true
                }
                return false
            })
            completion(filteredDishes)
        }
    }
    
    func getVidups(_ completion: @escaping ((_ vidups: [MFDish])->Void)) -> DatabaseConnectionObserver? {
        return self.getDishes(type: MFDishMediaType.vidup, frequency: .realtime) { (dishes) in
            let filteredDishes: [MFDish] = dishes.filter({ (dish) -> Bool in
                if dish.endTimestamp?.timeIntervalSinceReferenceDate ?? 0 > Date().timeIntervalSinceReferenceDate {
                    return true
                }
                return false
            })
            completion(filteredDishes)
        }
    }
    
    func getDishes(type: MFDishMediaType, frequency: DatabaseRetrievalFrequency, _ completion: @escaping ((_ dishes: [MFDish])->Void)) -> DatabaseConnectionObserver? {
        
        let successClosure: FirebaseObserverSuccessClosure  = { (snapshot) in
            guard let rawList = snapshot.value as? FirebaseDictionary else {
                completion([])
                return
            }
            var dishes: [MFDish] = []
            for (_,rawDish) in rawList.enumerated() {
                let rawDishFirebase: FirebaseDictionary = rawDish.value as? FirebaseDictionary ?? [:]
                dishes.append(self.createDish(from: rawDishFirebase))
            }
            completion(dishes)
        }
        
        let cancelClosure: FirebaseObserverCancelClosure = { (error) in
            print(error)
            completion([])
        }
        
        let databaseReference: DatabaseReference = FirebaseReference.dishes.classReference
        let databaseQuery: DatabaseQuery = databaseReference.queryOrdered(byChild: "mediaType").queryEqual(toValue: type.rawValue)
        switch frequency {
        case .realtime:
            var observer: DatabaseConnectionObserver = DatabaseConnectionObserver()
            observer.databaseReference = databaseReference
            observer.observerId = observer.databaseReference!.observe(.value, with: successClosure, withCancel: cancelClosure)
            return observer
        default:
            databaseQuery.observeSingleEvent(of: .value, with: successClosure, withCancel: cancelClosure)
        }
        return nil
    }
    
    func createDish(from rawDish: FirebaseDictionary) -> MFDish {
        let dish: MFDish = MFDish()
        dish.availableSlots = rawDish["availableSlots"] as? UInt ?? 0
        dish.commentsCount = rawDish["commentsCount"] as? Double ?? 0
        dish.createTimestamp = Date(timeIntervalSinceReferenceDate: rawDish["createTimestamp"] as? TimeInterval ?? 0)
        
        dish.numberOfViewers = rawDish["numberOfViewers"] as? UInt ?? 0
        dish.nonUniqueViewersCount = rawDish["nonUniqueViewersCount"] as? UInt ?? 0
        
        if let rawCuisine: FirebaseDictionary = rawDish["cuisine"] as? FirebaseDictionary {
            let cuisine: MFCuisine = MFCuisine.init(with: rawCuisine)
            dish.cuisine = cuisine
        }
        
        dish.description = rawDish["description"] as? String ?? ""
        
        if let rawDishType = rawDish["dishType"] as? String {
            if let dishType: MFDishType = MFDishType(rawValue: rawDishType) {
                dish.dishType = dishType
            }
        }
        
        if let timeinterval = rawDish["endTimestamp"] as? TimeInterval {
            dish.endTimestamp = Date(timeIntervalSinceReferenceDate: timeinterval)
        }
        
        dish.id = rawDish["id"] as? String ?? ""
        dish.likesCount = rawDish["likesCount"] as? Double ?? 0
        
        if let rawDishMediaType = rawDish["mediaType"] as? String {
            if let dishMediaType: MFDishMediaType = MFDishMediaType(rawValue: rawDishMediaType) {
                dish.mediaType = dishMediaType
            }
        }
        
        if let rawMediaURL: String = rawDish["mediaURL"] as? String {
            if let mediaURL: URL = URL(string: rawMediaURL) {
                dish.mediaURL = mediaURL
            }
        }
        
        dish.name = rawDish["name"] as? String ?? ""
        dish.preparationTime = rawDish["preparationTime"] as? TimeInterval ?? 0
        dish.pricePerSlot = rawDish["pricePerSlot"] as? Double ?? 0
        dish.totalSlots = rawDish["totalSlots"] as? UInt ?? 0
        
        if let rawUser: FirebaseDictionary = rawDish["user"] as? FirebaseDictionary {
            let user: MFUser = MFUser()
            user.id = rawUser["id"] as? String ?? ""
            user.name = rawUser["name"] as? String ?? ""
            dish.user = user
        }
        
        return dish
    }
    
    func saveDish(_ dish : MFDish, completion : @escaping (Error?) -> Void) {
        let dishDict = MFModelsToFirebaseDictionaryConverter.dictionary(from: dish)
        FirebaseReference.dishes.classReference.child(dish.id).updateChildValues(dishDict) { (error, ref) in
            completion(error)
        }
    }
}

// MARK: - DishComments
extension DatabaseGateway {
    
    func getComments(on dish: MFDish, frequency: DatabaseRetrievalFrequency, completion: @escaping (([MFComment])->Void)) -> DatabaseConnectionObserver? {
        let successClosure: FirebaseObserverSuccessClosure  = { (snapshot) in
            guard let rawList = snapshot.value as? FirebaseDictionary else {
                completion([])
                return
            }
            var comments: [MFComment] = []
            //            for key in rawList.keys {
            //                if let rawComment: FirebaseDictionary = rawList[key] as? FirebaseDictionary {
            //                    comments.append(self.createComment(from: rawComment))
            //                }
            //            }
            
            //            if let rawComment: FirebaseDictionary =  as? FirebaseDictionary {
            comments.append(self.createComment(from: rawList))
            //            }
            
            completion(comments)
        }
        
        let cancelClosure: FirebaseObserverCancelClosure = { (error) in
            print(error)
            completion([])
        }
        
        let databaseReference: DatabaseReference = FirebaseReference.dishComments.classReference
        let databaseQuery: DatabaseQuery = databaseReference.child(dish.id)
        switch frequency {
        case .realtime:
            var observer: DatabaseConnectionObserver = DatabaseConnectionObserver()
            observer.databaseReference = databaseReference
            observer.observerId = databaseQuery.observe(DataEventType.childAdded, with: successClosure, withCancel: cancelClosure)
            return observer
        default:
            databaseQuery.observeSingleEvent(of: .value, with: successClosure, withCancel: cancelClosure)
        }
        return nil
    }
    
    func createComment(from rawComment: FirebaseDictionary) -> MFComment {
        let comment: MFComment = MFComment.init(from: rawComment)
        return comment
    }
    
    func createUser(from rawUser: FirebaseDictionary) -> MFUser {
        let user: MFUser = MFUser()
        user.id = rawUser["id"] as? String ?? ""
        user.name = rawUser["name"] as? String ?? ""
        return user
    }
    
    func postComment(_ comment: MFComment, on dish: MFDish, _ completion: @escaping (()->Void)) {
        let rawComment: FirebaseDictionary = MFModelsToFirebaseDictionaryConverter.dictionary(from: comment)
        FirebaseReference.dishComments.get(with: dish.id).child(comment.id).updateChildValues(rawComment) { (error, databaseReference) in
            completion()
        }
    }
}

// MARK: - Media
extension DatabaseGateway {
    func saveMedia(_ media : MFDish, completion : @escaping (Error?) -> Void) {
        let mediaDict = MFModelsToFirebaseDictionaryConverter.dictionary(from: media)
        FirebaseReference.media.classReference.child(media.id).updateChildValues(mediaDict) { (error, ref) in
            completion(error)
        }
    }
}

// MARK: - Save Image and Video
extension DatabaseGateway {
    
    func save(data : Data, at path : String, completion : @escaping (URL?, Error?) -> Void) {
        let storageRef = Storage.storage().reference()
        let pathRef = storageRef.child(path)
        pathRef.putData(data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                completion(nil, error)
                return
            }
            completion(metadata.downloadURL(), nil)
        }
    }
    
    func save(fileAt : URL, at path : String, completion : @escaping (URL?, Error?) -> Void) {
        let storageRef = Storage.storage().reference()
        let pathRef = storageRef.child(path)
        pathRef.putFile(from: fileAt, metadata: nil) { (metaData, error) in
            guard let metadata = metaData else {
                completion(nil, error)
                return
            }
            completion(metadata.downloadURL(), error)
        }
    }
    
    
    func save(image : UIImage, at path : String, completion : @escaping (URL?, Error?) -> Void) {
        if let imageData = UIImageJPEGRepresentation(image, 1.0) {
            self.save(data: imageData, at: path, completion: completion)
        } else {
            completion(nil, NSError.init(domain: "Image is invalid", code: 401, userInfo: nil))
        }
    }
    
    func save(video : URL, at path : String, completion : @escaping (URL?, Error?) -> Void) {
        self.save(fileAt: video, at: path, completion: completion)
    }
}


//get Followers and following list of an user
extension DatabaseGateway{
    
    func getFollowersForUser(userID:String, frequency:DatabaseRetrievalFrequency = .single, _ completion:@escaping (_ followers:[String:AnyObject]?)->Void) -> DatabaseConnectionObserver?{
        
        
        let successClosure: FirebaseObserverSuccessClosure  = { (snapshot) in
            guard let followers = snapshot.value as? FirebaseDictionary else {
                completion(nil)
                return
            }
            
            completion(followers)
        }
        
        let cancelClosure: FirebaseObserverCancelClosure = { (error) in
            print(error)
            completion([:])
        }
        
        let databaseReference: DatabaseReference = FirebaseReference.followers.classReference
        let databaseQuery: DatabaseQuery = databaseReference.child(userID)
        
        switch frequency {
        case .realtime:
            var observer: DatabaseConnectionObserver = DatabaseConnectionObserver()
            observer.databaseReference = databaseReference
            observer.observerId = databaseQuery.observe(.value, with: successClosure, withCancel: cancelClosure)
            return observer
        case .single:
            databaseQuery.observeSingleEvent(of: .value, with: successClosure, withCancel: cancelClosure)
            return nil
        }
        
    }
    
    func getFollowingForUser(userID:String,frequency:DatabaseRetrievalFrequency = .single, _ completion:@escaping (_ following:[String:AnyObject]?)->Void)-> DatabaseConnectionObserver?{
        
        
        let successClosure: FirebaseObserverSuccessClosure  = { (snapshot) in
            guard let followers = snapshot.value as? FirebaseDictionary else {
                completion(nil)
                return
            }
            
            completion(followers)
        }
        
        let cancelClosure: FirebaseObserverCancelClosure = { (error) in
            print(error)
            completion([:])
        }
        
        let databaseReference: DatabaseReference = FirebaseReference.following.classReference
        let databaseQuery: DatabaseQuery = databaseReference.child(userID)
        
        switch frequency {
        case .realtime:
            var observer: DatabaseConnectionObserver = DatabaseConnectionObserver()
            observer.databaseReference = databaseReference
            observer.observerId = databaseQuery.observe(.value, with: successClosure, withCancel: cancelClosure)
            return observer
        case .single:
            databaseQuery.observeSingleEvent(of: .value, with: successClosure, withCancel: cancelClosure)
            return nil
        }
        
    }
    
    
    func checkIfUser(withuserID:String, isFollowing userID:String, _ completion:@escaping (Bool)->Void){
        
        //If withUserID is in followers list of userID, return true
        FirebaseReference.followers.classReference.child(userID).observeSingleEvent(of: .value, with: { (dataSnapshot) in
            
            guard let followers = dataSnapshot.value as? FirebaseDictionary else {
                completion(false)
                return
            }
            
            if followers[withuserID] != nil {
                completion(true)
            } else {
                completion(false)
            }
            
        })
        
    }
    
    
}


// Get media paths
extension DatabaseGateway {
    func getUserProfilePicturePath(for userId: String) -> URL? {
        return FirebaseReference.users.getImagePath(with: userId)
    }
}

// Get Order Detail
extension DatabaseGateway {
    
    func createOrder(_ order: MFOrder, completion: @escaping ((Error?) -> Void)) {
        let rawOrder = MFModelsToFirebaseDictionaryConverter.dictionary(from: order)
        FirebaseReference.orders.classReference.child(order.id).setValue(rawOrder)
    }
    
    func getordersWith(_ completion: @escaping ((_ order:MFOrder?) -> Void)){
        FirebaseReference.orders.classReference.observeSingleEvent(of: .value, with: { (ordersDataSnapshot) in
            guard let ordersData = ordersDataSnapshot.value as? FirebaseDictionary else {
                completion(nil)
                return
            }
            let order: MFOrder = MFOrder(from: ordersData)
            completion(order)
        }) { (error) in
            print(error)
            completion(nil)
        }
    }
}


//Get Notifications for Users

extension DatabaseGateway{
    
    func getNotificationsForUser(userID:String, completion:@escaping ([String:AnyObject]?) -> Void) {
        FirebaseReference.notificationsForUser.classReference.child(userID).observeSingleEvent(of: .value, with: { (dataSnapshot) in
            guard let notificationData = dataSnapshot.value as? FirebaseDictionary else {
                completion(nil)
                return
            }
            completion(notificationData)
        })
    }
    
    func getNotification(notificationID:String, completion:@escaping (MFNotification?)->()) {
        FirebaseReference.notifications.classReference.child(notificationID).observeSingleEvent(of: .value, with: { (dataSnapshot) in
            guard let notificationData = dataSnapshot.value as? FirebaseDictionary else {
                completion(nil)
                return
            }
            let notification:MFNotification = MFNotification(from:notificationData)
            completion(notification)
        })
    }
}


extension DatabaseGateway {
    
    func getAddressForUser(userID:String, _ completion:@escaping ([String:AnyObject]?)->()){
        FirebaseReference.userAddress.classReference.child(userID).observeSingleEvent(of: .value, with: { (dataSnapshot) in
            
            guard let notificationData = dataSnapshot.value as? FirebaseDictionary else {
                completion(nil)
                return
            }
            
            completion(notificationData)
        })
    }
    
    func getAddress(addressID:String,_ completion:@escaping (MFUserAddress?)->()) {
        FirebaseReference.address.classReference.child(addressID).observeSingleEvent(of: .value, with: { (dataSnapshot) in
            guard let addressData = dataSnapshot.value as? FirebaseDictionary else {
                completion(nil)
                return
            }
            let address:MFUserAddress = MFUserAddress(from:addressData)
            completion(address)
        })
    }
    
    func createAddress(userID: String, address:MFUserAddress, _ completion :@escaping (_ addressID:String?)->()){
        
        var newModel = address
        let id = FirebaseReference.address.generateAutoID()
        newModel.id = id
        
        let rawAddress: FirebaseDictionary = MFModelsToFirebaseDictionaryConverter.dictionary(from: newModel)
        let childUpdates = ["\(FirebaseReference.address.rawValue)/\(id)/":rawAddress, "/\(FirebaseReference.userAddress.rawValue)/\(userID)/\(id)/":true] as [AnyHashable : Any]
        
        print(childUpdates)
        
        let databaseRef = Database.database().reference()
        
        databaseRef.updateChildValues(childUpdates) { (error, databaseReference) in
            
            if error != nil {
                completion(nil)
            } else {
                completion(id)
            }
        }
        
    }
    
    func updateAddress(addressID:String, address:MFUserAddress,_ completion:@escaping (_ status:Bool)->()) {
        var address = address
        address.id = addressID
        let rawAddress: FirebaseDictionary = MFModelsToFirebaseDictionaryConverter.dictionary(from: address)
        FirebaseReference.address.classReference.child(addressID).updateChildValues(rawAddress) {
            (error, databaseReference) in
            if error != nil {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
}
extension DatabaseGateway {
    
    func addToken(_ token: String, completion: @escaping ((String,Error?)->Void)) {
        let userId: String = self.getLoggedInUser()!.id
        
        let ref = Database.database().reference().child(FirebaseReference.stripeCustomers.rawValue).child(userId).child("sources")
        let pushId = ref.childByAutoId().key
        let token = [ "token": token as Any]
        
        ref.child(pushId).updateChildValues(token) { (error, databaseRef) in
            print(databaseRef)
            databaseRef.parent?.observe(DataEventType.childChanged, with: { (snapshot) in
                print(snapshot.value ?? "")
                if let cardDetails = snapshot.value as? [String:Any] {
                    if let id = cardDetails["id"] as? String {
                        completion(id, nil)
                    } else {
                        completion("", error)
                        print("nooooo")
                    }
                } else {
                    completion("", error)
                    print("Noooo")
                }
            })
        }
    }
    
    func getPaymentSources(for userId: String, completion: @escaping (([String:AnyObject]?)->Void)) {
        let ref = Database.database().reference().child(FirebaseReference.stripeCustomers.rawValue).child(userId).child("sources")
        ref.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            guard let sources: FirebaseDictionary = snapshot.value as? FirebaseDictionary else {
                completion(nil)
                return
            }
            completion(sources)
        })
    }
    
    func createCharge(_ amount: Double, source: String, fromUserId: String, toUserId: String, completion: @escaping ((Error?)->Void)) {
        let userId: String = fromUserId
        let ref = Database.database().reference().child(FirebaseReference.stripeCustomers.rawValue).child(userId).child("charges")
        let pushId = ref.childByAutoId().key
        
        let charge = [ "amount": amount as Any, "source": source, "toUserId": toUserId]
        
        ref.child(pushId).updateChildValues(charge) { (error, databaseRef) in
            completion(error)
        }
    }
    
    //    func updateWalletBalance(with newBalance: Double, completion: @escaping ((Error?)->Void)) {
    //        let userId: String = self.getLoggedInUser()!.id
    //        let url = "https://us-central1-mammafoodie-baf82.cloudfunctions.net/updateWalletBalance"
    //        let parameters = [
    //            "userId": userId,
    //            "amountToAdd": newBalance
    //            ] as Parameters
    //        Alamofire.request(url, parameters: parameters).responseJSON { (response) in
    //            print(response)
    //            completion(nil)
    //        }
    //    }
    
    //    func transfer(amount: Double, from fromUserId: String, to toUserId: String, completion: @escaping ((Bool)->Void)) {
    //        let url = "https://us-central1-mammafoodie-baf82.cloudfunctions.net/transferBalance"
    //        let parameters = [
    //            "fromUserId": fromUserId,
    //            "toUserId": toUserId,
    //            "amount": amount
    //            ] as Parameters
    //        Alamofire.request(url, parameters: parameters).responseString { (response) in
    //            if let responseString = response.result.value {
    //                if responseString.lowercased() == "success" {
    //                    completion(true)
    //                } else if responseString.lowercased() == "insufficient balance" {
    //                    completion(false)
    //                } else {
    //                    print("Nooo")
    //                    completion(false)
    //                }
    //            }
    //        }
    //    }
    
    func uploadProfileImage(userID:String, image:UIImage, _ completion : @escaping (URL?, Error?) -> Void){
        let path = "users/\(userID).jpg"
        self.save(image: image, at: path, completion: completion)
    }
    
}
