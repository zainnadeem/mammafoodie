import UIKit

protocol RegisterInteractorInput {
    func updateShadow()

}

protocol RegisterInteractorOutput {
    func updateShadow()

}

class RegisterInteractor: RegisterInteractorInput {
    
    var output: RegisterInteractorOutput!
    var worker: RegisterWorker!
    
    // MARK: - Business logic
    func updateShadow()
    {
        output.updateShadow()
    }
}
