import FirebaseDatabase
import FirebaseCore

enum FirebaseReference: String {
    
    case media = "Media"
    case liveVideos = "LiveVideos"
    case dishRequests = "DishRequests"
    case dishes = "Dishes"
    case conversations = "Conversations"
    case orders = "Orders"
    case paymentDetails = "PaymentDetails"
    case comments = "Comments"
    case notifications = "Notifications"
    case newsFeed = "NewsFeed"
    case liveVideoGatewayAccountDetails = "LiveVideoGatewayAccountDetails"
    
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

enum DataRetrievalFrequency {
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
        FirebaseReference.liveVideos.get(with: id).observeSingleEvent(of: .value, with: { (streamNameDataSnapshot) in
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
    
    func getLiveStreams(frequency: DataRetrievalFrequency = .single, _ completion: @escaping ([MFMedia])->Void) {
        
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
            FirebaseReference.liveVideos.classReference.observe(.value, with: successClosure, withCancel: cancelClosure)
        default:
            FirebaseReference.liveVideos.classReference.observeSingleEvent(of: .value, with: successClosure, withCancel: cancelClosure)
        }
    }
    
    // Need to update this
    func createLiveStreamModel(from streamName: String, id: String) -> MFMedia? {
        var liveStream: MFMedia = MFMedia()
        liveStream.id = streamName
        liveStream.contentId = streamName
        return liveStream
    }
    
    func publishNewLiveStream(with name: String, _ completion: @escaping ((MFMedia?)->Void)) {
        var liveStream: MFMedia = MFMedia()
        liveStream.id = FirebaseReference.liveVideos.generateAutoID()
        liveStream.contentId = name
        let rawLiveStream: FirebaseDictionary = MFModelsToFirebaseDictionaryConverter.dictionary(from: liveStream)
        
        FirebaseReference.liveVideos.classReference.updateChildValues(rawLiveStream, withCompletionBlock: { (error, databaseReference) in
            if error != nil {
                print(error!)
            } else {
                
            }
            completion(liveStream)
        })
    }
    
    func unpublishLiveStream(_ liveStream: MFMedia, _ completion: @escaping (()->Void)) {
        FirebaseReference.liveVideos.get(with: liveStream.id).removeValue { (error, databaseReference) in
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
    
    func getLiveVideoGatewayAccountDetails(frequency: DataRetrievalFrequency = .single, _ completion: @escaping (MFLiveVideoGatewayAccountDetails?)->Void) -> DatabaseConnectionObserver? {
        
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
