import UIKit

protocol LoginPresenterInput {
    func signUpCompletion(errorMessage:String?)
    func loginCompletion(errorMessage:String?)
    
    //    func loginSuccess()
    //    func logoutSuccess()
    //    func present(_ viewController: UIViewController)
    //    func dismiss(_ viewController:UIViewController)
    func forgotpasswordCompletion(errorMessage:String?)
    func logoutCompletion(errorMessage:String?)
    func viewControllerToPresent() -> UIViewController
}

protocol LoginPresenterOutput: class {
//    func showLoginSuccessMessage(_ message: String)
//    func showLogoutSuccessMessage(_ message: String)
//    func present(_ viewController: UIViewController)
//    func dismiss(_ viewController: UIViewController)
//    func forgotpasswordWorker(success:String)
    
    
    func showHomeScreen()
    func showAlert(alertController:UIAlertController)
    

    func viewControllerToPresent() -> UIViewController
}

class LoginPresenter: LoginPresenterInput {
    weak var output: LoginPresenterOutput!
    
    // MARK: - Presentation logic

    
    func signUpCompletion(errorMessage:String?){
        
        if let errorMessage = errorMessage{
            let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            self.output.showAlert(alertController: alertController)
        } else {
            self.output.showHomeScreen()
        }
        
    }
    
    func loginCompletion(errorMessage:String?){
        
        if let errorMessage = errorMessage{
            let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            self.output.showAlert(alertController: alertController)
        } else {
            self.output.showHomeScreen()
        }
    }
    
    func forgotpasswordCompletion(errorMessage:String?){
        
        if let errorMessage = errorMessage{
            let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            self.output.showAlert(alertController: alertController)
        } else {
            self.output.showHomeScreen()
        }
    }
    
    func logoutCompletion(errorMessage:String?){
        
        var title = ""
        var msg = ""
        
        if let errorMessage = errorMessage{
            title = "Error"
            msg = errorMessage
        } else {
            title = "Success"
            msg = "Logged out successfully"
        }
        
        let alertController = UIAlertController(title: title , message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.output.showAlert(alertController: alertController)
    }
    
    
    func viewControllerToPresent() -> UIViewController {
        return self.output.viewControllerToPresent()
    }
    
}
