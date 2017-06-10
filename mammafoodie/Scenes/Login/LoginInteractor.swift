import UIKit
import SafariServices

protocol LoginInteractorInput {
    func login(with email: String, password: String)
}

protocol LoginInteractorOutput {
    func loginSuccess()
}

class LoginInteractor: LoginInteractorInput {
    var output: LoginInteractorOutput!
    
    // MARK: - Business logic
    
    func login(with email: String, password: String) {
        let worker: LoginWorker! = LoginWorker()
        worker.login(with: email, password: password, completion: {
            self.output.loginSuccess()
        })
    }
    
}
