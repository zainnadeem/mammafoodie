import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension VidupMainPageViewController: VidupMainPagePresenterOutput {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.passDataToNextScene(segue: segue, sender: sender)
    }
}

extension VidupMainPageInteractor: VidupMainPageViewControllerOutput {
}

extension VidupMainPagePresenter: VidupMainPageInteractorOutput {
}

class VidupMainPageConfigurator {
    
    // MARK: - Object lifecycle
    static let sharedInstance = VidupMainPageConfigurator()
    private init() {}
    
    // MARK: - Configuration
    
    func configure(viewController: VidupMainPageViewController) {
        let router = VidupMainPageRouter()
        router.viewController = viewController
        viewController.router = router
        
        let interactor = VidupMainPageInteractor()
        let presenter = VidupMainPagePresenter()
        viewController.output = interactor
        interactor.output = presenter
        presenter.output = viewController
    }
}
