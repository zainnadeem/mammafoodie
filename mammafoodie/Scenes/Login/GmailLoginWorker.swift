import Foundation
import GoogleSignIn
import Firebase

class GmailLoginWorker: NSObject {
    
    weak var viewController: UIViewController!
    
    fileprivate var signInCompletionHandler : ((_ errorMessage: String?, _ authCredential: AuthCredential?, _ email: String?, _ name: String?)->())!
    
    private func setup() {
        //Gmail Details
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().shouldFetchBasicProfile = true
        GIDSignIn.sharedInstance().delegate = self
    }
    
    private func signin() {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    func signIn(completion:@escaping (_ errorMessage: String?, _ authCredential: AuthCredential?, _ email: String?, _ name: String?)->()) {
        self.signInCompletionHandler = completion
        self.setup()
        self.signin()
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
            self.signInCompletionHandler(error.localizedDescription, nil, nil, nil)
            return
        }
        
        guard let authentication = user.authentication else {
            self.signInCompletionHandler("Unable to login with Gmail. Please try again", nil, nil, nil)
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        self.signInCompletionHandler(nil, credential, user.profile.email, user.profile.name)
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
