import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension NearbyChefsViewController: NearbyChefsPresenterOutput {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.passDataToNextScene(segue: segue, sender: sender)
    }
}

extension NearbyChefsInteractor: NearbyChefsViewControllerOutput {
}

extension NearbyChefsPresenter: NearbyChefsInteractorOutput {
}

class NearbyChefsConfigurator {

    // MARK: - Object lifecycle
    
    static let sharedInstance = NearbyChefsConfigurator()
    
    private init() {}
    
    // MARK: - Configuration
    
    func configure(viewController: NearbyChefsViewController) {
        let router = NearbyChefsRouter()
        router.viewController = viewController
        viewController.router = router
        
        let interactor = NearbyChefsInteractor()
        let presenter = NearbyChefsPresenter()
        viewController.output = interactor
        interactor.output = presenter
        presenter.output = viewController
    }
}
