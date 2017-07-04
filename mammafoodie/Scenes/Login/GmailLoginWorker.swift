import Foundation
import GoogleSignIn
import Firebase

class GmailLoginWorker: NSObject {
   
    weak var viewController: UIViewController!

   fileprivate var signInCompletionHandler : ((_ errorMessage:String?, _ authCredential:AuthCredential?)->())!
    
    private func setup() {
        //Gmail Details
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
    }
    
   private func signin() {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    func signIn(completion:@escaping (_ errorMessage:String?, _ authCredential:AuthCredential?)->()){
        self.signInCompletionHandler = completion
        setup()
        signin()
    }
    
    func signout(){
        let firebaseAuth = Auth.auth()
        GIDSignIn.sharedInstance().signOut()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    class func canApplicationOpenURL(_ url: URL, sourceApplication: String?) -> Bool {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: [:])
    }
}

extension GmailLoginWorker: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            signInCompletionHandler(error.localizedDescription, nil)
            return
        }
        
        guard let authentication = user.authentication else {
           signInCompletionHandler("Unable to login with Gmail. Please try again", nil)
           return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        signInCompletionHandler(nil,credential) // Pass credential back to Interactor
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
}

extension GmailLoginWorker: GIDSignInUIDelegate {
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.viewController.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
