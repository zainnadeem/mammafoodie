import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension GoCookViewController: GoCookPresenterOutput {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.passDataToNextScene(segue: segue)
    }
}

extension GoCookInteractor: GoCookViewControllerOutput {
}

extension GoCookPresenter: GoCookInteractorOutput {
}

class GoCookConfigurator {

    // MARK: - Object lifecycle
    
    static let sharedInstance = GoCookConfigurator()
    
    private init() {}
    
    // MARK: - Configuration
    
    func configure(viewController: GoCookViewController) {
        let router = GoCookRouter()
        router.viewController = viewController
        viewController.router = router
        
        let interactor = GoCookInteractor()
        let presenter = GoCookPresenter()
        viewController.output = interactor
        interactor.output = presenter
        presenter.output = viewController
        presenter.viewController = viewController
    }
}
