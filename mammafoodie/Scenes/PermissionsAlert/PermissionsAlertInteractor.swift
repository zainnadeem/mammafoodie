import UIKit

protocol PermissionsAlertInteractorInput {
    func displayDefaultCameraPermissionAlert()
    func displayDefaultPhotoLibraryPermissionAlert()
    func displayDefaultMicrophonePermissionAlert()
    func displayDefaultLocationPermissionAlert()
    
}

protocol PermissionsAlertInteractorOutput {
    func permissionShown()
    
}

class PermissionsAlertInteractor: PermissionsAlertInteractorInput {
    
    var output: PermissionsAlertInteractorOutput!
    var enableLocationsWorker = EnableLocationWorker()
    var enableCameraWorker = EnableCameraWorker()
    var enableMicrophoneWorker = EnableMicrophoneWorker()
    var enablePhotoLibraryWorker = EnablePhotoLibraryWorker()
    
    // MARK: - Business logic
    
    func displayDefaultCameraPermissionAlert() {
        self.enableCameraWorker.showDefaultCameraPermission()
    }
    
    func displayDefaultMicrophonePermissionAlert() {
       self.enableMicrophoneWorker.showDefaultMicrophonePermission()
    }
    
    func displayDefaultLocationPermissionAlert() {
        self.enableLocationsWorker.showDefaultLocationPermission()
    }
    
    func displayDefaultPhotoLibraryPermissionAlert() {
        self.enablePhotoLibraryWorker.showDefaultPhotoLibraryPermission()
    }
}
