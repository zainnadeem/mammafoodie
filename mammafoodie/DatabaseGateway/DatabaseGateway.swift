import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

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
    case notifications = "Notifications"
    case newsFeed = "NewsFeed"
    case liveVideoGatewayAccountDetails = "LiveVideoGatewayAccountDetails"
    case users = "Users"
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
    
    // temporary class for LiveVideoDemo. We will need to delete this later on
    case tempLiveVideosStreamNames = "TempLiveVideosStreamNames"
    
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
    
    func getLiveStream(with id: String, _ completion: @escaping ((MFDish?)->Void)) {
        FirebaseReference.tempLiveVideosStreamNames.get(with: id).observeSingleEvent(of: .value, with: { (streamNameDataSnapshot) in
            guard let liveStreamName = streamNameDataSnapshot.value as? String else {
                completion(nil)
                return
            }
            let liveStream: MFDish? = self.createLiveStreamModel(from: liveStreamName, id: id)
            completion(liveStream)
        }) { (error) in
            print(error)
            completion(nil)
        }
    }
    
    func getLiveStreams(frequency: DatabaseRetrievalFrequency = .single, _ completion: @escaping ([MFDish])->Void) {
        
        let successClosure: FirebaseObserverSuccessClosure = { (streamNamesDataSnapshot) in
            guard let rawLiveStreams: FirebaseDictionary = streamNamesDataSnapshot.value as? FirebaseDictionary else {
                completion([])
                return
            }
            var liveStreams: [MFDish] = []
            for rawLiveStreamKey in rawLiveStreams.keys {
                guard let liveStreamName = rawLiveStreams[rawLiveStreamKey] as? String else {
                    continue
                }
                guard let liveStream: MFDish = self.createLiveStreamModel(from: liveStreamName, id: rawLiveStreamKey) else {
                    continue
                }
                liveStreams.append(liveStream)
            }
            completion(liveStreams)
        }
        
        let cancelClosure: FirebaseObserverCancelClosure = { (error) in
            print(error)
            completion([])
        }
        
        switch frequency {
        case .realtime:
            FirebaseReference.tempLiveVideosStreamNames.classReference.observe(.value, with: successClosure, withCancel: cancelClosure)
        default:
            FirebaseReference.tempLiveVideosStreamNames.classReference.observeSingleEvent(of: .value, with: successClosure, withCancel: cancelClosure)
        }
    }
    
    func createLiveStreamModel(from streamName: String, id: String) -> MFDish? {
        let liveStream: MFDish = MFDish()
        liveStream.id = id
        //        liveStream.contentId = streamName
        return liveStream
    }
    
    func publishNewLiveStream(with name: String, _ completion: @escaping ((MFDish?)->Void)) {
        let liveStream: MFDish = MFDish()
        liveStream.id = FirebaseReference.tempLiveVideosStreamNames.generateAutoID()
        //        liveStream.contentId = name
        let rawLiveStream: FirebaseDictionary = MFModelsToFirebaseDictionaryConverter.dictionary(from: liveStream)
        
        FirebaseReference.tempLiveVideosStreamNames.classReference.updateChildValues(rawLiveStream, withCompletionBlock: { (error, databaseReference) in
            if error != nil {
                print(error!)
            } else {
                
            }
            completion(liveStream)
        })
    }
    
    func unpublishLiveStream(_ liveStream: MFDish, _ completion: @escaping (()->Void)) {
        FirebaseReference.tempLiveVideosStreamNames.get(with: liveStream.id).removeValue { (error, databaseReference) in
            if error != nil {
                print(error!)
            } else {
                
            }
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

// MARK: - Conversation
extension DatabaseGateway {
    
    func createConversation(with model: MFConversation1, _ completion: @escaping ((_ chatData:MFConversation1)->Void)) {
        var newModel = model
        newModel.id = FirebaseReference.conversations.generateAutoID()
        
        let currentDate = Date()
        let dateString = FirebaseReference.conversations.dateConvertion(with: currentDate)
        newModel.createdAt = dateString
        
        let rawConversation: FirebaseDictionary = MFModelsToFirebaseDictionaryConverter.dictionary(from: newModel)
        FirebaseReference.conversations.classReference.updateChildValues(rawConversation) { (error, databaseReference) in
            completion(newModel)
        }
    }
}

// MARK: - Messages
extension DatabaseGateway {
    
    func createMessage(with model: MFMessage1, _ completion: @escaping (()->Void)) {
        
        var newModel = model
        newModel.messageid = FirebaseReference.messages.generateAutoID()
        
        let currentDate = Date()
        let dateString = FirebaseReference.messages.dateConvertion(with: currentDate)
        newModel.datetime = dateString
        
        let rawConversation: FirebaseDictionary = MFModelsToFirebaseDictionaryConverter.dictionary(from: newModel)
        FirebaseReference.messages.classReference.updateChildValues(rawConversation) { (error, databaseReference) in
            completion()
        }
        
    }
}


//MARK: - User
extension DatabaseGateway {
    
    func createUserEntity(with model: MFUser, _ completion: @escaping ((_ errorMessage:String?)->Void)) {
        
        let rawUsers: FirebaseDictionary = MFModelsToFirebaseDictionaryConverter.dictionary(from: model)
        
        FirebaseReference.users.classReference.updateChildValues(rawUsers) { (error, databaseReference) in
            completion(error?.localizedDescription)
        }
    }
    
    func updateUserEntity(with model:MFUser, _ completion: @escaping ((_ errorMessage:String?)->Void)){
        
        let rawUserData:FirebaseDictionary = MFModelsToFirebaseDictionaryConverter.dictionary(from: model)
        
        let id :String = "\(model.id!)"
        let userProfileData = rawUserData[id] as! FirebaseDictionary
        
        FirebaseReference.users.classReference.child(model.id!).updateChildValues(userProfileData) { (error, databaseReference) in
            
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
            
            FirebaseReference.dishes.classReference.child(dishID).observeSingleEvent(of: .value, with: successClosure, withCancel: cancelClosure)
            
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
        
        let rawUserData:FirebaseDictionary = MFModelsToFirebaseDictionaryConverter.dictionary(from: model)
        
        let id :String = "\(model.id)"
        let userProfileData = rawUserData[id] as! FirebaseDictionary
        
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
}

//Mark: - Liked Dish

extension DatabaseGateway {
    
    func checkLikedDishes(userId: String, dishId: String, _ completion: @escaping (_ status:Bool?) -> Void){
        
        print(userId)
        print(dishId)
        
        
    FirebaseReference.dishLikes.classReference.child(dishId).observeSingleEvent(of: .value, with: {(dishSnapshot) in
            
            guard let userData = dishSnapshot.value as? FirebaseDictionary else {
                print(dishSnapshot.value)
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
    
    func getNewsFeed(for userId: String, _ completion: @escaping (([MFNewsFeed])->Void)) {
        let successClosure: FirebaseObserverSuccessClosure  = { (snapshot) in
            guard let rawNewsFeed: FirebaseDictionary = snapshot.value as? FirebaseDictionary else {
                completion([])
                return
            }
            let newsFeed: MFNewsFeed? = self.createNewsFeedModel(from: rawNewsFeed)
            completion([newsFeed!])
        }
        
        let cancelClosure: FirebaseObserverCancelClosure = { (error) in
            print(error)
            completion([])
        }
        
        FirebaseReference.newsFeed.classReference.observe(.value, with: successClosure, withCancel: cancelClosure)
    }
    
    func createNewsFeedModel(from raw: FirebaseDictionary) -> MFNewsFeed {
        var feed: MFNewsFeed = MFNewsFeed()
        return feed
    }
}

//MARK: NewsFeed

extension DatabaseGateway {
    
    func getNewsFeedWith(newsFeedID:String, _ completion:@escaping (_ activity:MFNewsFeed?)->Void ) {
        
        FirebaseReference.newsFeed.classReference.child(newsFeedID).observeSingleEvent(of: .value, with: { (userDataSnapshot) in
            guard let newsFeedData = userDataSnapshot.value as? FirebaseDictionary else {
                completion(nil)
                return
            }
            let newsFeed:MFNewsFeed = MFNewsFeed(from: newsFeedData)
            
            completion(newsFeed)
        }) { (error) in
            print(error)
            completion(nil)
        }
        
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
                if dish.endTimestamp?.timeIntervalSinceReferenceDate ?? 0 > 0 {
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
        dish.createdAt = Date(timeIntervalSinceReferenceDate: rawDish["createTimestamp"] as? TimeInterval ?? 0)
        
        if let rawCuisine: FirebaseDictionary = rawDish["cuisine"] as? FirebaseDictionary {
            var cuisine: MFCuisine = MFCuisine.init(with: rawCuisine)
            dish.cuisine = cuisine
        }
        
        dish.description = rawDish["description"] as? String ?? ""
        
        if let rawDishType = rawDish["dishType"] as? String {
            if let dishType: MFDishType = MFDishType(rawValue: rawDishType) {
                dish.dishType = dishType
            }
        }
        
        dish.endTimestamp = Date(timeIntervalSinceReferenceDate: rawDish["endTimestamp"] as? TimeInterval ?? 0)
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
        FirebaseReference.dishes.classReference.updateChildValues(dishDict) { (error, ref) in
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
        let comment: MFComment = MFComment()
        comment.id = rawComment["id"] as? String ?? ""
        comment.text = rawComment["text"] as? String ?? ""
        
        if let timeInterval: TimeInterval = rawComment["createTimestamp"] as? TimeInterval {
            comment.createdAt = Date(timeIntervalSinceReferenceDate: timeInterval)
        }
        
        if let rawUser: FirebaseDictionary = rawComment["user"] as? FirebaseDictionary {
            comment.user = self.createUser(from: rawUser)
        }
        
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
        FirebaseReference.dishComments.get(with: dish.id).updateChildValues(rawComment) { (error, databaseReference) in
            completion()
        }
    }
}

// MARK: - Media
extension DatabaseGateway {
    func saveMedia(_ media : MFDish, completion : @escaping (Error?) -> Void) {
        let mediaDict = MFModelsToFirebaseDictionaryConverter.dictionary(from: media)
        FirebaseReference.media.classReference.updateChildValues(mediaDict) { (error, ref) in
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
    
    func getFollowersForUser(userID:String, _ completion:@escaping (_ followers:[String:AnyObject]?)->Void){
        
        FirebaseReference.followers.classReference.child(userID).observeSingleEvent(of: .value, with: { (dataSnapshot) in
            
            guard let followers = dataSnapshot.value as? FirebaseDictionary else {
                completion(nil)
                return
            }
            
            completion(followers)
        })
    }
    
    func getFollowingForUser(userID:String, _ completion:@escaping (_ following:[String:AnyObject]?)->Void){
        
        FirebaseReference.following.classReference.child(userID).observeSingleEvent(of: .value, with: { (dataSnapshot) in
            
            guard let following = dataSnapshot.value as? FirebaseDictionary else {
                completion(nil)
                return
            }
            
            completion(following)
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
    
    func getordersWith(_ completion: @escaping ((_ order:MFOrder?)->Void)){
        
        FirebaseReference.orders.classReference.observeSingleEvent(of: .value, with: { (ordersDataSnapshot) in
            guard let ordersData = ordersDataSnapshot.value as? FirebaseDictionary else {
                completion(nil)
                return
            }
            
            let order:MFOrder = MFOrder(from: ordersData)
            completion(order)
        }) { (error) in
            print(error)
            completion(nil)
        }
    }
}
