import UIKit

protocol LoginPresenterInput {
    func loginSuccess()
    func logoutSuccess()
    func present(_ viewController: UIViewController)
}

protocol LoginPresenterOutput: class {
    func showLoginSuccessMessage(_ message: String)
    func showLogoutSuccessMessage(_ message: String)
    func present(_ viewController: UIViewController)
    func dismiss(_ viewController: UIViewController)
}

class LoginPresenter: LoginPresenterInput {
    weak var output: LoginPresenterOutput!
    
    // MARK: - Presentation logic
    func loginSuccess() {
        let message = "Login was successful."
        self.output.showLoginSuccessMessage(message)
    }
    func logoutSuccess() {
        let message = "Logout was successful"
        self.output.showLogoutSuccessMessage(message)
    }
    
    func present(_ viewController: UIViewController) {
        self.output.present(viewController)
    }
    func dismiss(_ viewController: UIViewController) {
        self.output.dismiss(viewController)
    }
}
