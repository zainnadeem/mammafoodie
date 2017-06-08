import UIKit

protocol LoginInteractorInput {
    func login(with email: String, password: String)
    func loginWithFacebook()
    func logoutWithFacebook()
}

protocol LoginInteractorOutput {
    func loginSuccess()
    func viewControllerToPresent() -> UIViewController
}

class LoginInteractor: NSObject, LoginInteractorInput {
    var output: LoginInteractorOutput!
    
    // MARK: - Business logic
    
    func login(with email: String, password: String) {
        let worker: LoginWorker! = LoginWorker()
        worker.login(with: email, password: password, completion: {
            self.output.loginSuccess()
        })
    }
    
    func loginWithFacebook() {
        let worker = FacebookLoginWorker()
        worker.viewController = self.output.viewControllerToPresent()
        worker.login()
    }

    func logoutWithFacebook(){
        let worker = FacebookLoginWorker()
        worker.logout()
    }
}
