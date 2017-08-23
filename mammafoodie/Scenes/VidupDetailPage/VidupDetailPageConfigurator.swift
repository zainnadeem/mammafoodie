import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension DealDetailViewController: VidupDetailPagePresenterOutput {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.passDataToNextScene(segue: segue, sender: sender)
    }
}

extension VidupDetailPageInteractor: DealDetailViewControllerOutput {
}

extension VidupDetailPagePresenter: VidupDetailPageInteractorOutput {
}

class VidupDetailPageConfigurator {

    // MARK: - Object lifecycle
    
    static let sharedInstance = VidupDetailPageConfigurator()
    
    private init() {}
    
    // MARK: - Configuration
    
    func configure(viewController: DealDetailViewController) {
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
