import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension LoginViewController: LoginPresenterOutput {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.openSegue(segue)
    }
}

extension LoginInteractor: LoginViewControllerOutput {
}

extension LoginPresenter: LoginInteractorOutput {
}

class LoginConfigurator {
    // MARK: - Object lifecycle
    
    static let sharedInstance = LoginConfigurator()
    
    private init() {}
    
    // MARK: - Configuration
    
    func configure(viewController: LoginViewController) {
        let router = LoginRouter()
        router.viewController = viewController
        viewController.router = router
        
        let interactor = LoginInteractor()
        let presenter = LoginPresenter()
        viewController.output = interactor
        interactor.output = presenter
        presenter.output = viewController
    }
}


