import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension LiveVideoMainPageViewController: LiveVideoMainPagePresenterOutput {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.passDataToNextScene(segue: segue)
    }
}

extension LiveVideoMainPageInteractor: LiveVideoMainPageViewControllerOutput {
}

extension LiveVideoMainPagePresenter: LiveVideoMainPageInteractorOutput {
}

class LiveVideoMainPageConfigurator {

    // MARK: - Object lifecycle
    
    static let sharedInstance = LiveVideoMainPageConfigurator()
    
    private init() {}
    
    // MARK: - Configuration
    
    func configure(viewController: LiveVideoMainPageViewController) {
        let router = LiveVideoMainPageRouter()
        router.viewController = viewController
        viewController.router = router
        
        let interactor = LiveVideoMainPageInteractor()
        let presenter = LiveVideoMainPagePresenter()
        viewController.output = interactor
        interactor.output = presenter
        presenter.output = viewController
    }
}
