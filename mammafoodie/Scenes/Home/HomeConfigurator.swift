import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension HomeViewController: HomePresenterOutput {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.passDataToNextScene(segue: segue, sender: sender)
    }
}

extension HomeInteractor: HomeViewControllerOutput {
}

extension HomePresenter: HomeInteractorOutput {
}

class HomeConfigurator {

    // MARK: - Object lifecycle
    
    static let sharedInstance = HomeConfigurator()
    
    private init() {}
    
    // MARK: - Configuration
    
    func configure(viewController: HomeViewController) {
        let router = HomeRouter()
        router.viewController = viewController
        viewController.router = router
        
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        viewController.output = interactor
        interactor.output = presenter
        presenter.output = viewController
    }
}
