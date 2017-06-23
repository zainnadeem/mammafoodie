import GoogleSignIn
import Firebase

class ForgotPasswordWorker {
    
    func callApI(email:String, completion: @escaping (_ errorMessage:String?)->()) {
        
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                
                if error != nil {
                    completion(error!.localizedDescription)
                }
                else {
                    completion(nil)
//                    print(email)
                }
            }
        }
}
