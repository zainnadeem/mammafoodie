import UIKit

protocol PermissionsAlertViewControllerInput {
    
}

protocol PermissionsAlertViewControllerOutput {
   func displayDefaultCameraPermissionAlert()
   func displayDefaultMicrophonePermissionAlert()
   func displayDefaultLocationPermissionAlert()
   func displayDefaultPhotoLibraryPermissionAlert()
    
}

class PermissionsAlertViewController: UIViewController, PermissionsAlertViewControllerInput {
    
    var output: PermissionsAlertViewControllerOutput!
    var router: PermissionsAlertRouter!
    
    
    @IBAction func btnCameraPermissionTapped(_ sender: Any) {
        print("button Pressed")
        self.output.displayDefaultCameraPermissionAlert()
    }
   
    @IBAction func btnMicrophonePermissionTapped(_ sender: Any) {
        self.output.displayDefaultMicrophonePermissionAlert()
    }
    
    
    @IBAction func btnLocationPermissionTapped(_ sender: Any) {
        self.output.displayDefaultLocationPermissionAlert()
    }
    
    @IBAction func btnPhotoLibraryPermissionTapped(_ sender: Any) {
        self.output.displayDefaultPhotoLibraryPermissionAlert()
    }
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        PermissionsAlertConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Event handling
    
    // MARK: - Display logic
    
}
