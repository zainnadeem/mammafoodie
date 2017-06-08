import UIKit

protocol LoginPresenterInput {
    func loginSuccess()
}

protocol LoginPresenterOutput: class {
    func showLoginSuccessMessage(_ message: String)
}

class LoginPresenter: LoginPresenterInput {
    weak var output: LoginPresenterOutput!
    
    // MARK: - Presentation logic
    
    func loginSuccess() {
        let message = "Login was successful."
        self.output.showLoginSuccessMessage(message)
    }
}
