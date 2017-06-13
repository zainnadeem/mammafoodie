import GoogleSignIn
import Firebase

class ForgotPasswordWorker {
    
    func callApI(email:String, completion: @escaping (_ success:Bool, _ errorMessage:String?)->()) {
        
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                // Your code here
                if error != nil {
                    completion(false, error!.localizedDescription)
                }
                else {
                    completion(true, nil)
                    print(email)
                }
            }
        }
}
