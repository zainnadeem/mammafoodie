import UIKit

protocol ForgotPasswordPresenterInput {
    func forgotpasswordCompletion(errorMessage:String?)
}

protocol ForgotPasswordPresenterOutput: class {
    
}

class ForgotPasswordPresenter: ForgotPasswordPresenterInput, HUDRenderer {
    weak var output: ForgotPasswordPresenterOutput!
    
    // MARK: - Presentation logic
    
    func forgotpasswordCompletion(errorMessage:String?){
        
        var message = ""
        var title = ""
        
        if let errorMessage = errorMessage{
          message = errorMessage
            title = "Error"
        } else {
            message = "You can reset your password by following the instructions sent to you on your registered email."
            title = "Success"
        }
        
        showAlert(title: title, message: message, okButtonText: "OK", cancelButtonText: nil, handler: { _ in})
        
    }

    
}
