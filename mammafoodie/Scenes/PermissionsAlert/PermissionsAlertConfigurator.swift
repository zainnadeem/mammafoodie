import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension PermissionsAlertViewController: PermissionsAlertPresenterOutput {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.passDataToNextScene(segue: segue)
    }
}

extension PermissionsAlertInteractor: PermissionsAlertViewControllerOutput {

}

extension PermissionsAlertPresenter: PermissionsAlertInteractorOutput {
}

class PermissionsAlertConfigurator {

    // MARK: - Object lifecycle
    
    static let sharedInstance = PermissionsAlertConfigurator()
    
    private init() {}
    
    // MARK: - Configuration
    
    func configure(viewController: PermissionsAlertViewController) {
        let router = PermissionsAlertRouter()
        router.viewController = viewController
        viewController.router = router
        
        let interactor = PermissionsAlertInteractor()
        let presenter = PermissionsAlertPresenter()
        viewController.output = interactor
        interactor.output = presenter
        presenter.output = viewController
    }
}
