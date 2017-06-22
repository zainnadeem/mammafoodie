import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension RegisterViewController: RegisterPresenterOutput {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.passDataToNextScene(segue: segue)
    }
}

extension RegisterInteractor: RegisterViewControllerOutput {
}

extension RegisterPresenter: RegisterInteractorOutput {
}

class RegisterConfigurator {

    // MARK: - Object lifecycle
    
    static let sharedInstance = RegisterConfigurator()
    
    private init() {}
    
    // MARK: - Configuration
    
    func configure(viewController: RegisterViewController) {
        let router = RegisterRouter()
        router.viewController = viewController
        viewController.router = router
        
        let interactor = RegisterInteractor()
        let presenter = RegisterPresenter()
        viewController.output = interactor
        interactor.output = presenter
        presenter.output = viewController
        presenter.viewcontroller = viewController
    }
}
