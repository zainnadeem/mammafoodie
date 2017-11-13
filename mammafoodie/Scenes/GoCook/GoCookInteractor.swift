import UIKit

protocol GoCookInteractorInput {
    func prepareOptions()
    func selectOption(option : MFDishMediaType)
    func showStep1()
    func showStep2(_ animated: Bool)
}

protocol GoCookInteractorOutput {
    func prepareOptions()
    func selectOption(option : MFDishMediaType)
    func showStep1()
    func showStep2(_ animated: Bool)
}

class GoCookInteractor: GoCookInteractorInput {
    
    var output: GoCookInteractorOutput!
    var worker: GoCookWorker!
    
    // MARK: - Business logic
    func prepareOptions() {
        self.output.prepareOptions()
    }
    
    func selectOption(option: MFDishMediaType) {
        self.output.selectOption(option: option)
    }
    
    func showStep1() {
        self.output.showStep1()
    }
    
    func showStep2(_ animated: Bool) {
        self.output.showStep2(animated)
    }
    
}
