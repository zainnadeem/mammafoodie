import UIKit
import Foundation
import AVFoundation


class EnableCameraWorker {
    
    func showDefaultCameraPermission(){
        let mediaType = AVMediaTypeVideo
        if AVCaptureDevice.authorizationStatus(forMediaType: mediaType) == .notDetermined{
            AVCaptureDevice.requestAccess(forMediaType: mediaType) {
                (granted) in
                if granted == true {
                    print("Granted access to \(mediaType)" )
                } else {
                    print("Not granted access to \(mediaType)")
                }                
            }
        }else{
  
        }
    }
}
