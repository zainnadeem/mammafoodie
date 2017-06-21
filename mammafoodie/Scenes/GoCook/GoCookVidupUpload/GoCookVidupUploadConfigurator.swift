import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension GoCookVidupUploadViewController: GoCookVidupUploadPresenterOutput {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.passDataToNextScene(segue: segue)
    }
}

extension GoCookVidupUploadInteractor: GoCookVidupUploadViewControllerOutput {
}

extension GoCookVidupUploadPresenter: GoCookVidupUploadInteractorOutput {
}

class GoCookVidupUploadConfigurator {

    // MARK: - Object lifecycle
    
    static let sharedInstance = GoCookVidupUploadConfigurator()
    
    private init() {}
    
    // MARK: - Configuration
    
    func configure(viewController: GoCookVidupUploadViewController) {
        let router = GoCookVidupUploadRouter()
        router.viewController = viewController
        viewController.router = router
        
        let interactor = GoCookVidupUploadInteractor()
        let presenter = GoCookVidupUploadPresenter()
        viewController.output = interactor
        interactor.output = presenter
        presenter.output = viewController
    }
}
