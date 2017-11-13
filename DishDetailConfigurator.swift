import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension DishDetailViewController: DishDetailPresenterOutput {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.passDataToNextScene(segue: segue)
    }
}

extension DishDetailInteractor: DishDetailViewControllerOutput {
}

extension DishDetailPresenter: DishDetailInteractorOutput {
}

class DishDetailConfigurator {

    // MARK: - Object lifecycle
    
    static let sharedInstance = DishDetailConfigurator()
    
    private init() {}
    
    // MARK: - Configuration
    
    func configure(viewController: DishDetailViewController) {
        let router = DishDetailRouter()
        router.viewController = viewController
        viewController.router = router
        
        let interactor = DishDetailInteractor()
        let presenter = DishDetailPresenter()
        viewController.output = interactor
        interactor.output = presenter
        presenter.output = viewController
    }
}
