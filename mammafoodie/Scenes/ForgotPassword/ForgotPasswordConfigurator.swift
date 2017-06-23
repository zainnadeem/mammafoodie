import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension ForgotPasswordViewController: ForgotPasswordPresenterOutput {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.passDataToNextScene(segue: segue)
    }
}

extension ForgotPasswordInteractor: ForgotPasswordViewControllerOutput {
}

extension ForgotPasswordPresenter: ForgotPasswordInteractorOutput {
}

class ForgotPasswordConfigurator {

    // MARK: - Object lifecycle
    
    static let sharedInstance = ForgotPasswordConfigurator()
    
    private init() {}
    
    // MARK: - Configuration
    
    func configure(viewController: ForgotPasswordViewController) {
        let router = ForgotPasswordRouter()
        router.viewController = viewController
        viewController.router = router
        
        let interactor = ForgotPasswordInteractor()
        let presenter = ForgotPasswordPresenter()
        viewController.output = interactor
        interactor.output = presenter
        presenter.output = viewController
    }
}
