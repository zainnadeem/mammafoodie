import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension GoCookStep2ViewController: GoCookStep2PresenterOutput {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.passDataToNextScene(segue: segue)
    }
}

extension GoCookStep2Interactor: GoCookStep2ViewControllerOutput {
}

extension GoCookStep2Presenter: GoCookStep2InteractorOutput {
}

class GoCookStep2Configurator {

    // MARK: - Object lifecycle
    
    static let sharedInstance = GoCookStep2Configurator()
    
    private init() {}
    
    // MARK: - Configuration
    
    func configure(viewController: GoCookStep2ViewController) {
        let router = GoCookStep2Router()
        router.viewController = viewController
        viewController.router = router
        
        let interactor = GoCookStep2Interactor()
        let presenter = GoCookStep2Presenter()
        viewController.output = interactor
        interactor.output = presenter
        presenter.output = viewController
    }
}
