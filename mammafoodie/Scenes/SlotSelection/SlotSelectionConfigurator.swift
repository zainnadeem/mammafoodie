import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension SlotSelectionViewController: SlotSelectionPresenterOutput {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.passDataToNextScene(segue: segue)
    }
}

extension SlotSelectionInteractor: SlotSelectionViewControllerOutput {
}

extension SlotSelectionPresenter: SlotSelectionInteractorOutput {
}

class SlotSelectionConfigurator {

    // MARK: - Object lifecycle
    
    static let sharedInstance = SlotSelectionConfigurator()
    
    private init() {}
    
    // MARK: - Configuration
    
    func configure(viewController: SlotSelectionViewController) {
        let router = SlotSelectionRouter()
        router.viewController = viewController
        viewController.router = router
        
        let interactor = SlotSelectionInteractor()
        let presenter = SlotSelectionPresenter()
        viewController.output = interactor
        interactor.output = presenter
        presenter.output = viewController
    }
}
