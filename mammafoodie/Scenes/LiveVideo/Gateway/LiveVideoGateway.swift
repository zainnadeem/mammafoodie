import Foundation
import R5Streaming

protocol LiveVideoGatewayDelegate {
    //    func gatewaySetupCompleted()
    //    func gatewayConnected()
    //    func gatewayDisconnected()
    func streamPublished()
    func streamSubscribed()
    //    func streamReconnected()
}

class LiveVideoGateway: NSObject {
    
    var delegate: LiveVideoGatewayDelegate?
    private var configurations: R5Configuration! = R5Configuration()
    private var hasLoadedConfigurations: Bool = false
    private var liveStream: R5Stream?
    
    lazy var publishViewController: LiveVideoPublisherViewController = LiveVideoPublisherViewController()
    lazy var subscriberViewController: LiveVideoSubscriberViewController = LiveVideoSubscriberViewController()
    
    var configurationDataObserver: DatabaseConnectionObserver?
    
    typealias ConfigurationsDownloadSuccessClosure = (_ success: Bool)->Void
    
    override init() {
        super.init()
    }
    
    func getConfigurations(_ completion: @escaping ConfigurationsDownloadSuccessClosure) {
        self.configurationDataObserver = DatabaseGateway.sharedInstance.getLiveVideoGatewayAccountDetails(frequency: .realtime, { (accountDetails) in
            if accountDetails != nil {
                self.hasLoadedConfigurations = true
                print("Configurations downloaded successfully")
                self.configurations.host = accountDetails!.host
                self.configurations.port = accountDetails!.port
                self.configurations.contextName = "live"
                self.configurations.licenseKey = accountDetails!.sdkKey
                //                self.configurations.buffer_time = 20
                completion(true)
            } else {
                print("Could not download Gateway Configurations")
                completion(false)
            }
        })
    }
    
    func setup() {
        //        self.delegate?.gatewaySetupCompleted()
    }
    
    func connect() {
        //        self.delegate?.gatewayConnected()
    }
    
    func disconnect() {
        //        self.delegate?.gatewayDisconnected()
    }
    
    func publish(with name: String, _ completion: (_ cameraView: UIView)->Void) {
        self.publishViewController.configurations = self.configurations!
        self.publishViewController.preview()
        self.publishViewController.startPublishing(with: name)
        
        self.liveStream = self.publishViewController.stream
        
        completion(self.publishViewController.view)
        
        self.delegate?.streamPublished()
    }
    
    func stop() {
        self.liveStream?.stop()
        self.liveStream?.delegate = nil
        self.liveStream = nil
        self.configurationDataObserver?.stop()
    }
    
    func subscribe(_ streamName: String, _ completion: (_ cameraView: UIView)->Void) {
        self.subscriberViewController.configurations = self.configurations!
        self.subscriberViewController.start(with: streamName)
        
        self.liveStream = self.subscriberViewController.stream
        
        completion(self.subscriberViewController.view)
        
        self.delegate?.streamSubscribed()
    }
    
    //    func getCurrentLiveVideoView() -> UIView? {
    //        return nil
    //    }
}

extension LiveVideoGateway: R5StreamDelegate {
    func onR5StreamStatus(_ stream: R5Stream!, withStatus statusCode: Int32, withMessage msg: String!) {
        
    }
}
