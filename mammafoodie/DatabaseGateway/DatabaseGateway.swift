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
    case conversations = "Conversations"
    case messages = "Messages"
    case orders = "Orders"
    case paymentDetails = "PaymentDetails"
    case comments = "Comments"
    case notifications = "Notifications"
    case newsFeed = "NewsFeed"
    case liveVideoGatewayAccountDetails = "LiveVideoGatewayAccountDetails"
    
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
    
    func getLiveStream(with id: String, _ completion: @escaping ((MFMedia?)->Void)) {
        FirebaseReference.tempLiveVideosStreamNames.get(with: id).observeSingleEvent(of: .value, with: { (streamNameDataSnapshot) in
            guard let liveStreamName = streamNameDataSnapshot.value as? String else {
                completion(nil)
                return
            }
            let liveStream: MFMedia? = self.createLiveStreamModel(from: liveStreamName, id: id)
            completion(liveStream)
        }) { (error) in
            print(error)
            completion(nil)
        }
    }
    
    func getLiveStreams(frequency: DatabaseRetrievalFrequency = .single, _ completion: @escaping ([MFMedia])->Void) {
        
        let successClosure: FirebaseObserverSuccessClosure = { (streamNamesDataSnapshot) in
            guard let rawLiveStreams: FirebaseDictionary = streamNamesDataSnapshot.value as? FirebaseDictionary else {
                completion([])
                return
            }
            var liveStreams: [MFMedia] = []
            for rawLiveStreamKey in rawLiveStreams.keys {
                guard let liveStreamName = rawLiveStreams[rawLiveStreamKey] as? String else {
                    continue
                }
                guard let liveStream: MFMedia = self.createLiveStreamModel(from: liveStreamName, id: rawLiveStreamKey) else {
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
    
    func createLiveStreamModel(from streamName: String, id: String) -> MFMedia? {
        let liveStream: MFMedia = MFMedia()
        liveStream.id = id
        liveStream.contentId = streamName
        return liveStream
    }
    
    func publishNewLiveStream(with name: String, _ completion: @escaping ((MFMedia?)->Void)) {
        let liveStream: MFMedia = MFMedia()
        liveStream.id = FirebaseReference.tempLiveVideosStreamNames.generateAutoID()
        liveStream.contentId = name
        let rawLiveStream: FirebaseDictionary = MFModelsToFirebaseDictionaryConverter.dictionary(from: liveStream)
        
        FirebaseReference.tempLiveVideosStreamNames.classReference.updateChildValues(rawLiveStream, withCompletionBlock: { (error, databaseReference) in
            if error != nil {
                print(error!)
            } else {
                
            }
            completion(liveStream)
        })
    }
    
    func unpublishLiveStream(_ liveStream: MFMedia, _ completion: @escaping (()->Void)) {
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

// MARK: - Media
extension DatabaseGateway {
    func save(image : UIImage, at path : String, completion : @escaping (URL?) -> Void) {
        let storageRef = Storage.storage().reference()
        let imagePathRef = storageRef.child(path)
        if let imageData = UIImageJPEGRepresentation(image, 1.0) {
            let uploadTask = imagePathRef.putData(imageData, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    completion(nil)
                    return
                }
                completion(metadata.downloadURL())
            }
            uploadTask.resume()
        } else {
            completion(nil)
        }
    }
    
    func save(video : URL, at path : String, completion : @escaping (URL?) -> Void) {
        let storageRef = Storage.storage().reference()
        let videoPathRef = storageRef.child(path)
        let fileManager : FileManager = FileManager.default
        if fileManager.fileExists(atPath: video.absoluteString) {
            videoPathRef.putFile(from: video, metadata: nil) { (metaData, error) in
                guard let metadata = metaData else {
                    completion(nil)
                    return
                }
                completion(metadata.downloadURL())
            }
        } else {
            completion(nil)
        }
    }
}
