import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension VidupDetailPageViewController: VidupDetailPagePresenterOutput {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.passDataToNextScene(segue: segue)
    }
}

extension VidupDetailPageInteractor: VidupDetailPageViewControllerOutput {
}

extension VidupDetailPagePresenter: VidupDetailPageInteractorOutput {
}

class VidupDetailPageConfigurator {

    // MARK: - Object lifecycle
    
    static let sharedInstance = VidupDetailPageConfigurator()
    
    private init() {}
    
    // MARK: - Configuration
    
    func configure(viewController: VidupDetailPageViewController) {
        let router = VidupDetailPageRouter()
        router.viewController = viewController
        viewController.router = router
        
        let interactor = VidupDetailPageInteractor()
        let presenter = VidupDetailPagePresenter()
        viewController.output = interactor
        interactor.output = presenter
        presenter.output = viewController
    }
}
