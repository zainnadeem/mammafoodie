import UIKit
import Photos

class EnablePhotoLibraryWorker {
    
    func showDefaultPhotoLibraryPermission(){
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    print("photo access granted")
                } else {
                    print("photo access is not granted")
                }
            })
        }
    }
}
