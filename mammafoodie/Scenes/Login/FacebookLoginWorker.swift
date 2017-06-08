import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class FacebookLoginWorker {
    weak var viewController: UIViewController!
    let loginManager = FBSDKLoginManager()
    
    class func setup(application: UIApplication, with launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    class func openURL(_ url: URL, application: UIApplication, source: String, annotation: Any!) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: source , annotation: annotation)
        return handled
    }
    
    func login() {
        
        loginManager.logIn(withReadPermissions:["email"] , from: self.viewController) { (loginResult, error) in
            
            if loginResult?.isCancelled == true {
                print("cancelled.")
            }else if ((loginResult?.declinedPermissions) != nil) {
                print("declined.")
            }
            else {
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                Auth.auth().signIn(with: credential, completion: { (user, error) in
                    if error != nil {
                        print("Login Failure.")
                        return
                    }
                    print("Login Sucessfully.")
                })
            }
        }
    }
    
    func logout() {
        
        do {
            try Auth.auth().signOut()
            loginManager.logOut()
        }catch {
            print("error")
        }
        
        
        
    }
}
