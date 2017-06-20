import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension RequestDishViewController: RequestDishPresenterOutput {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.passDataToNextScene(segue: segue)
    }
}

extension RequestDishInteractor: RequestDishViewControllerOutput {
}

extension RequestDishPresenter: RequestDishInteractorOutput {
}

class RequestDishConfigurator {

    // MARK: - Object lifecycle
    
    static let sharedInstance = RequestDishConfigurator()
    
    private init() {}
    
    // MARK: - Configuration
    
    func configure(viewController: RequestDishViewController) {
        let router = RequestDishRouter()
        router.viewController = viewController
        viewController.router = router
        
        let interactor = RequestDishInteractor()
        let presenter = RequestDishPresenter()
        viewController.output = interactor
        interactor.output = presenter
        presenter.output = viewController
    }
}
