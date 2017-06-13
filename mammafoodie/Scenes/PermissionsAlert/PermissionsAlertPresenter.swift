import UIKit

protocol PermissionsAlertPresenterInput {
    func permissionShown()
}

protocol PermissionsAlertPresenterOutput: class {
    
}

class PermissionsAlertPresenter: PermissionsAlertPresenterInput {
    weak var output: PermissionsAlertPresenterOutput!
    
    // MARK: - Presentation logic
    
    func permissionShown() {
        print("presenter permission shown")
    }
    
}
