import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension LocationSearchViewController: LocationSearchPresenterOutput {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.passDataToNextScene(segue: segue)
    }
}

extension LocationSearchInteractor: LocationSearchViewControllerOutput {
}

extension LocationSearchPresenter: LocationSearchInteractorOutput {
}

class LocationSearchConfigurator {

    // MARK: - Object lifecycle
    
    static let sharedInstance = LocationSearchConfigurator()
    
    private init() {}
    
    // MARK: - Configuration
    
    func configure(viewController: LocationSearchViewController) {
        let router = LocationSearchRouter()
        router.viewController = viewController
        viewController.router = router
        
        let interactor = LocationSearchInteractor()
        let presenter = LocationSearchPresenter()
        viewController.output = interactor
        interactor.output = presenter
        presenter.output = viewController
    }
}
