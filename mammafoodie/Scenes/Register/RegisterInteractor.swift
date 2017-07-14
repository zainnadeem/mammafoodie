import UIKit
import Firebase

protocol RegisterInteractorInput {
    func updateShadow()

}

protocol RegisterInteractorOutput {
    func updateShadow()
    func signUpCompletion(errorMessage:String?)

}

class RegisterInteractor: RegisterInteractorInput {
    
    var output: RegisterInteractorOutput!
    var worker: RegisterWorker!
    var firebaseworker = FirebaseLoginWorker()
    var model : MFUser!
    
    // MARK: - Business logic
    func updateShadow() {
        output.updateShadow()
    }
    
    func register(name: String, email: String, password: String)
    {
        print(email,password)

        firebaseworker.signUp(with: Login.Credentials(email:email,password:password)) { (errorMessage) in
            
            if errorMessage == nil {
               // print(self.model)
                
                let user: MFUser = MFUser()
                user.id = Auth.auth().currentUser!.uid
                user.name = name
                user.email = email
                
                self.model = user
                
                DatabaseGateway.sharedInstance.createUserEntity(with:self.model) {newModel in
                    print(self.model)
                }
            }
            self.output.signUpCompletion(errorMessage: errorMessage)
        }
    }

}
