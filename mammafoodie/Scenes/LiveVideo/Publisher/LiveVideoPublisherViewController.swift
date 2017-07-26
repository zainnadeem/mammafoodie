import UIKit
import R5Streaming
import AVKit

protocol LiveVideoPublisherDelegate {
    func onR5StreamStatus(_ stream: R5Stream!, withStatus statusCode: Int32, withMessage msg: String!)
}

class LiveVideoPublisherViewController: R5VideoViewController {
    
    var stream: R5Stream!
    var configurations: R5Configuration!
    var delegate: LiveVideoPublisherDelegate?
    var liveVideo: MFDish?
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - View lifecycle
    
    // MARK: - Event handling
    
    func preview() {
        
        self.showDebugInfo(false)
        
        let cameras: [Any] = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        let cameraDevice: AVCaptureDevice? = cameras.last as? AVCaptureDevice
        guard let camera: R5Camera = R5Camera(device: cameraDevice!, andBitRate: 512) else {
            print("camera was not initialized.")
            return
        }
        
        camera.orientation = 90
        camera.width = 480
        camera.height = 640
        camera.fps = 24
        camera.adaptiveBitRate = true
        
        let audioDevice: AVCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)
        let microphone = R5Microphone(device: audioDevice)
        
        let connection: R5Connection = R5Connection(config: self.configurations)
        
        self.stream = R5Stream(connection: connection)
        self.stream.attachVideo(camera)
        self.stream.attachAudio(microphone)
        
        self.stream.delegate = self
        self.attach(self.stream)
        self.showPreview(true)
    }
    
    func startPublishing(with streamName: String) {
        self.showPreview(false)
        self.stream.publish(streamName, type: R5RecordTypeLive)
    }
    
    func stopPublishing() {
        self.stream.stop()
        self.stream.delegate = nil
        self.preview()
    }
    
    // MARK: - Display logic
    
}

extension LiveVideoPublisherViewController: R5StreamDelegate {
    func onR5StreamStatus(_ stream: R5Stream!, withStatus statusCode: Int32, withMessage msg: String!) {
        self.delegate?.onR5StreamStatus(stream, withStatus: statusCode, withMessage: msg)
    }
}
