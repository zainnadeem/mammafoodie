import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension ChatListViewController: ChatListPresenterOutput {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.passDataToNextScene(segue: segue)
    }
}

extension ChatListInteractor: ChatListViewControllerOutput {
}

extension ChatListPresenter: ChatListInteractorOutput {
}

class ChatListConfigurator {

    // MARK: - Object lifecycle
    
    static let sharedInstance = ChatListConfigurator()
    
    private init() {}
    
    // MARK: - Configuration
    
    func configure(viewController: ChatListViewController) {
        let router = ChatListRouter()
        router.viewController = viewController
        viewController.router = router
        
        let interactor = ChatListInteractor()
        let presenter = ChatListPresenter()
        viewController.output = interactor
        interactor.output = presenter
        presenter.output = viewController
    }
}
