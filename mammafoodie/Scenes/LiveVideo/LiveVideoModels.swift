import UIKit

struct LiveVideo {
    
}

struct LiveVideoStreamStatus {
    var code: LiveVideoStreamStatusCode
    var message: String = ""
}

enum LiveVideoStreamStatusCode: Int32 {
    case connected = 0
    case disconnected = 1
    case invalidMedia = 2
    case closed = 4
    case startedStreaming = 5
    case unpublished = 7
    case validLicense = 13
    case unknown
}
