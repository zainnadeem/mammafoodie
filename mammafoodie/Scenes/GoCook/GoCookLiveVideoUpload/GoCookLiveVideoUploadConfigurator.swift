import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension GoCookLiveVideoUploadViewController: GoCookLiveVideoUploadPresenterOutput {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.passDataToNextScene(segue: segue)
    }
}

extension GoCookLiveVideoUploadInteractor: GoCookLiveVideoUploadViewControllerOutput {
}

extension GoCookLiveVideoUploadPresenter: GoCookLiveVideoUploadInteractorOutput {
}

class GoCookLiveVideoUploadConfigurator {

    // MARK: - Object lifecycle
    
    static let sharedInstance = GoCookLiveVideoUploadConfigurator()
    
    private init() {}
    
    // MARK: - Configuration
    
    func configure(viewController: GoCookLiveVideoUploadViewController) {
        let router = GoCookLiveVideoUploadRouter()
        router.viewController = viewController
        viewController.router = router
        
        let interactor = GoCookLiveVideoUploadInteractor()
        let presenter = GoCookLiveVideoUploadPresenter()
        viewController.output = interactor
        interactor.output = presenter
        presenter.output = viewController
    }
}
