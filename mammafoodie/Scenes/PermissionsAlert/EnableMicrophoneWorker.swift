import UIKit
import AVFoundation
import Foundation

class EnableMicrophoneWorker {
    
    func showDefaultMicrophonePermission(){
        AVAudioSession.sharedInstance().requestRecordPermission { result in
            if result == true {
                print("Access Allowed")
            }else{
                print("Access Denied")
            }
        }
    }
}

