import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension OtherUsersProfileViewController: OtherUsersProfilePresenterOutput {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.passDataToNextScene(segue: segue)
    }
}

extension OtherUsersProfileInteractor: OtherUsersProfileViewControllerOutput {
}

extension OtherUsersProfilePresenter: OtherUsersProfileInteractorOutput {
}

class OtherUsersProfileConfigurator {

    // MARK: - Object lifecycle
    
    static let sharedInstance = OtherUsersProfileConfigurator()
    
    private init() {}
    
    // MARK: - Configuration
    
    func configure(viewController: OtherUsersProfileViewController) {
        let router = OtherUsersProfileRouter()
        router.viewController = viewController
        viewController.router = router
        
        let interactor = OtherUsersProfileInteractor()
        let presenter = OtherUsersProfilePresenter()
        viewController.output = interactor
        interactor.output = presenter
        presenter.output = viewController
    }
}
