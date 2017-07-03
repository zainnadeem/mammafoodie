import Foundation
import R5Streaming

protocol LiveVideoGatewayDelegate {
    func gatewayConnected()
    func gatewayDisconnected()
    func streamPublished()
    func streamSubscribed()
    func streamClosed()
    func streamUnpublished()
    func unknownError(_ error: String)
    func insufficientBandwidth()
    func invalidMedia()
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
        self.publishViewController.delegate = self
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
        self.subscriberViewController.delegate = self
        
        self.liveStream = self.subscriberViewController.stream
        
        completion(self.subscriberViewController.view)
        
        self.delegate?.streamSubscribed()
    }
}

extension LiveVideoGateway: LiveVideoPublisherDelegate, LiveVideoSubscriberDelegate {
    func onR5StreamStatus(_ stream: R5Stream!, withStatus statusCode: Int32, withMessage msg: String!) {
        var streamStatusCode: LiveVideoStreamStatusCode? = .unknown
        if LiveVideoStreamStatusCode(rawValue: statusCode) != nil {
            streamStatusCode = LiveVideoStreamStatusCode(rawValue: statusCode)!
        }
        let status = LiveVideoStreamStatus(code: streamStatusCode!, message: msg)
        switch status.code {
        case .closed:
            self.delegate?.streamClosed()
        case .connected:
            self.delegate?.gatewayConnected()
        case .disconnected:
            self.delegate?.gatewayDisconnected()
        case .unpublished:
            self.delegate?.streamUnpublished()
        case .startedStreaming:
            self.delegate?.streamPublished()
        case .validLicense:
            print("Valid license")
        case .invalidMedia:
            self.delegate?.invalidMedia()
        case .unknown:
            self.delegate?.unknownError(msg)
        }
    }
}
