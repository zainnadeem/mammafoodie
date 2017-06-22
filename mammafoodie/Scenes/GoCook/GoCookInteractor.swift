import UIKit

protocol GoCookInteractorInput {
    func prepareOptions()
    func selectOption(option : GoCookOption)
    func showStep1()
    func showStep2()
}

protocol GoCookInteractorOutput {
    func prepareOptions()
    func selectOption(option : GoCookOption)
    func showStep1()
    func showStep2()
}

class GoCookInteractor: GoCookInteractorInput {
    
    var output: GoCookInteractorOutput!
    var worker: GoCookWorker!
    
    // MARK: - Business logic
    func prepareOptions() {
        self.output.prepareOptions()
    }
    
    func selectOption(option: GoCookOption) {
        self.output.selectOption(option: option)
    }
    
    func showStep1() {
        self.output.showStep1()
    }
    
    func showStep2() {
        self.output.showStep2()
    }
    
}
