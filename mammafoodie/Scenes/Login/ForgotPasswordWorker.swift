import GoogleSignIn
import Firebase

class ForgotPasswordWorker:HUDRenderer {
    
    func callApI(email:String, completion: @escaping (_ errorMessage:String?)->()) {
        
        showActivityIndicator()
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                self.hideActivityIndicator()
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
