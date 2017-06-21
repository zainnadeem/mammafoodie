import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension GoCookPictureUploadViewController: GoCookPictureUploadPresenterOutput {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.passDataToNextScene(segue: segue)
    }
}

extension GoCookPictureUploadInteractor: GoCookPictureUploadViewControllerOutput {
}

extension GoCookPictureUploadPresenter: GoCookPictureUploadInteractorOutput {
}

class GoCookPictureUploadConfigurator {

    // MARK: - Object lifecycle
    
    static let sharedInstance = GoCookPictureUploadConfigurator()
    
    private init() {}
    
    // MARK: - Configuration
    
    func configure(viewController: GoCookPictureUploadViewController) {
        let router = GoCookPictureUploadRouter()
        router.viewController = viewController
        viewController.router = router
        
        let interactor = GoCookPictureUploadInteractor()
        let presenter = GoCookPictureUploadPresenter()
        viewController.output = interactor
        interactor.output = presenter
        presenter.output = viewController
    }
}
