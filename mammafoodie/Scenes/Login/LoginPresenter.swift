import UIKit

protocol LoginPresenterInput {
    func loginSuccess()
    func viewControllerToPresent() -> UIViewController
}

protocol LoginPresenterOutput: class {
    func showLoginSuccessMessage(_ message: String)
    func viewControllerToPresent() -> UIViewController
}

class LoginPresenter: LoginPresenterInput {
    weak var output: LoginPresenterOutput!
    
    // MARK: - Presentation logic
    
    func loginSuccess() {
        let message = "Login was successful."
        self.output.showLoginSuccessMessage(message)
    }
    
    func viewControllerToPresent() -> UIViewController {
        return self.output.viewControllerToPresent()
    }
}
