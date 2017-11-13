import UIKit
import R5Streaming

protocol LiveVideoSubscriberViewControllerInput {
    
}

protocol LiveVideoSubscriberViewControllerOutput {
    
}

protocol LiveVideoSubscriberDelegate {
    func onR5StreamStatus(_ stream: R5Stream!, withStatus statusCode: Int32, withMessage msg: String!)
}

class LiveVideoSubscriberViewController: R5VideoViewController, LiveVideoSubscriberViewControllerInput {
    
    var output: LiveVideoSubscriberViewControllerOutput!
    
    var stream: R5Stream!
    var configurations: R5Configuration?
    var delegate: LiveVideoSubscriberDelegate?
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - View lifecycle
    
    
    // MARK: - Event handling
    
    func start(with streamName: String) {
        self.preferredFPS = 24
        self.showDebugInfo(false)
        let connection: R5Connection = R5Connection(config: self.configurations!)
        self.stream = R5Stream(connection: connection)
        self.attach(self.stream)
        self.stream.play(streamName)
        self.stream.delegate = self
    }
    
    
    // MARK: - Display logic
    
}

extension LiveVideoSubscriberViewController: R5StreamDelegate {
    func onR5StreamStatus(_ stream: R5Stream!, withStatus statusCode: Int32, withMessage msg: String!) {
        self.delegate?.onR5StreamStatus(stream, withStatus: statusCode, withMessage: msg)
    }
}
