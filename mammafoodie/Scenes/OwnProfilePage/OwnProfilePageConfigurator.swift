import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension OwnProfilePageViewController: OwnProfilePagePresenterOutput {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.passDataToNextScene(segue: segue)
    }
}

extension OwnProfilePageInteractor: OwnProfilePageViewControllerOutput {
}

extension OwnProfilePagePresenter: OwnProfilePageInteractorOutput {
}

class OwnProfilePageConfigurator {

    // MARK: - Object lifecycle
    
    static let sharedInstance = OwnProfilePageConfigurator()
    
    private init() {}
    
    // MARK: - Configuration
    
    func configure(viewController: OwnProfilePageViewController) {
        let router = OwnProfilePageRouter()
        router.viewController = viewController
        viewController.router = router
        
        let interactor = OwnProfilePageInteractor()
        let presenter = OwnProfilePagePresenter()
        viewController.output = interactor
        interactor.output = presenter
        presenter.output = viewController
    }
}
