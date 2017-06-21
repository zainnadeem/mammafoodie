import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension LiveVideoViewController: LiveVideoPresenterOutput {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.passDataToNextScene(segue: segue)
    }
}

extension LiveVideoInteractor: LiveVideoViewControllerOutput {
}

extension LiveVideoPresenter: LiveVideoInteractorOutput {
}

class LiveVideoConfigurator {

    // MARK: - Object lifecycle
    
    static let sharedInstance = LiveVideoConfigurator()
    
    private init() {}
    
    // MARK: - Configuration
    
    func configure(viewController: LiveVideoViewController) {
        let router = LiveVideoRouter()
        router.viewController = viewController
        viewController.router = router
        
        let interactor = LiveVideoInteractor()
        let presenter = LiveVideoPresenter()
        viewController.output = interactor
        interactor.output = presenter
        presenter.output = viewController
    }
}
