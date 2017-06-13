import UIKit
import SafariServices

protocol LoginInteractorInput {
    func login(with email: String, password: String)
    func loginWithGoogle()
    func logoutWithGoogle()
    func forgotpasswordWorker(email: String)
}

protocol LoginInteractorOutput {
    func loginSuccess()
    func logoutSuccess()
    func present(_ viewController: UIViewController)
    func dismiss(_ viewController:UIViewController)
    func forgotpasswordWorker(success:String)
}

class LoginInteractor: NSObject, LoginInteractorInput {
    
    
    var output: LoginInteractorOutput!
    lazy var gmailWorker = GmailLoginWorker()
    lazy var forgotPassWorker = ForgotPasswordWorker()

    
    // MARK: - Business logic
    func login(with email: String, password: String) {
        let worker: LoginWorker! = LoginWorker()
        worker.login(with: email, password: password, completion: {
            self.output.loginSuccess()
        })
    }
    
    //Passing Email From View
    func forgotpasswordWorker(email: String){
        print(email)
        forgotPassWorker.callApI(email: email) { (success, errorMessage) in
            //print(email)
            if errorMessage != nil {
                self.output.forgotpasswordWorker(success:errorMessage!)
            }
        }
    }

    
    func logout(with email: String, password: String) {
        let worker: LoginWorker! = LoginWorker()
        worker.logout(with: email, password: password, completion: {
            self.output.logoutSuccess()
        })
    }
    
    
    func loginWithGoogle() {
        self.gmailWorker.setup()
        self.gmailWorker.signin()
        self.gmailWorker.presentSignInViewController = { (viewController) in
            self.output.present(viewController)
        }
        self.gmailWorker.dismissSignInViewController = {(viewController) in
            self.output.dismiss(viewController)
        }
    }
    
    func logoutWithGoogle(){
        self.gmailWorker.signout()
    }
    

}
