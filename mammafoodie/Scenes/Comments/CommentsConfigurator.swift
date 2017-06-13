import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension CommentsViewController: CommentsPresenterOutput {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.passDataToNextScene(segue: segue)
    }
}

extension CommentsInteractor: CommentsViewControllerOutput {
}

extension CommentsPresenter: CommentsInteractorOutput {
}

class CommentsConfigurator {

    // MARK: - Object lifecycle
    
    static let sharedInstance = CommentsConfigurator()
    
    private init() {}
    
    // MARK: - Configuration
    
    func configure(viewController: CommentsViewController) {
        let router = CommentsRouter()
        router.viewController = viewController
        viewController.router = router
        
        let interactor = CommentsInteractor()
        let presenter = CommentsPresenter()
        viewController.output = interactor
        interactor.output = presenter
        presenter.output = viewController
                
    }
}
