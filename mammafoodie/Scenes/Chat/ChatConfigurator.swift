import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension ChatViewController: ChatPresenterOutput {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.passDataToNextScene(segue: segue)
    }
}

extension ChatInteractor: ChatViewControllerOutput {
}

extension ChatPresenter: ChatInteractorOutput {
}

class ChatConfigurator {

    // MARK: - Object lifecycle
    
    static let sharedInstance = ChatConfigurator()
    
    private init() {}
    
    // MARK: - Configuration
    
    func configure(viewController: ChatViewController) {
        let router = ChatRouter()
        router.viewController = viewController
        viewController.router = router
        
        let interactor = ChatInteractor()
        let presenter = ChatPresenter()
        viewController.output = interactor
        interactor.output = presenter
        presenter.output = viewController
    }
}
