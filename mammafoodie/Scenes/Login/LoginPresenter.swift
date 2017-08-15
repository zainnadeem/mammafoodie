import UIKit

protocol LoginPresenterInput {
    func signUpCompletion(errorMessage:String?)
    func loginCompletion(errorMessage:String?)
    func logoutCompletion(errorMessage:String?)
    func viewControllerToPresent() -> UIViewController
    func forgotpasswordCompletion(errorMessage:String?)
}

protocol LoginPresenterOutput: class {
    func showHomeScreen()
    func viewControllerToPresent() -> UIViewController
}

class LoginPresenter: LoginPresenterInput, HUDRenderer {
    
    weak var output: LoginPresenterOutput!
    
    // MARK: - Presentation logic
    func forgotpasswordCompletion(errorMessage:String?) {
        var message = ""
        var title = ""
        if let errorMessage = errorMessage {
            message = errorMessage
            title = "Error"
        } else {
            message = "You can reset your password by following the instructions sent to you on your registered email."
            title = "Success"
        }
        self.showAlert(title: title, message: message, okButtonText: "OK", cancelButtonText: nil, handler: { _ in})
        
    }
    
    func signUpCompletion(errorMessage:String?) {
        if let errorMessage = errorMessage {
            self.showAlert(title: "Error", message: errorMessage, okButtonText: "OK", cancelButtonText: nil, handler: { _ in})
        } else {
            self.output.showHomeScreen()
        }
        
    }
    
    func loginCompletion(errorMessage:String?) {
        if let errorMessage = errorMessage {
            self.showAlert(title: "Error!", message: errorMessage, okButtonText: "OK", cancelButtonText: nil, handler: { _ in})
            FirebaseLoginWorker().signOut({ (error) in
            })
        } else {
            self.output.showHomeScreen()
        }
        
    }
    
    func logoutCompletion(errorMessage:String?) {
        var title = ""
        var msg = ""
        if let errorMessage = errorMessage {
            title = "Error"
            msg = errorMessage
        } else {
            title = "Success"
            msg = "Logged out successfully"
        }
        self.showAlert(title: title, message: msg, okButtonText: "OK", cancelButtonText: nil, handler: { _ in})
        
    }
    
    
    func viewControllerToPresent() -> UIViewController {
        return self.output.viewControllerToPresent()
    }
    
}
