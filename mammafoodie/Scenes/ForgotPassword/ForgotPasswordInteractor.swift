import UIKit

protocol ForgotPasswordInteractorInput {
    func forgotpasswordWorker(email: String)
}

protocol ForgotPasswordInteractorOutput {
    func forgotpasswordCompletion(errorMessage:String?)
}

class ForgotPasswordInteractor: ForgotPasswordInteractorInput {
    
    var output: ForgotPasswordInteractorOutput!
    var worker: ForgotPasswordWorker!
    
    lazy var forgotPassWorker = ForgotPasswordWorker()
    
    // MARK: - Business logic
    
    //Passing Email From View
    func forgotpasswordWorker(email: String){
        print(email)
        forgotPassWorker.callApI(email: email) { (errorMessage) in
            //print(email)
            
                self.output.forgotpasswordCompletion(errorMessage:errorMessage)
            
        }
    }
    
}
