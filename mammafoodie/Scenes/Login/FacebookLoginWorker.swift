import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class FacebookLoginWorker {
    var dict : [String : AnyObject]!
    weak var viewController: UIViewController!
    let loginManager = FBSDKLoginManager()
    
    class func setup(application: UIApplication, with launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    class func openURL(_ url: URL, application: UIApplication, source: String, annotation: Any!) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: source , annotation: annotation)
        return handled
    }
    
    
    func login(){
        if  (Auth.auth().currentUser != nil) && (FBSDKAccessToken.current() != nil){
            if FBSDKAccessToken.current().expirationDate > Date(){
                FBSDKAccessToken.refreshCurrentAccessToken({ (request, result, error) in
                    print(error!)
                    print(result!)
                    print(request!)
                    
                })
                return
            }else{
                FBandFirebaselogin()
            }
        }else
        {
            FBandFirebaselogin()
        }
        
    }
    
    func FBandFirebaselogin() {
        loginManager.logIn(withReadPermissions:["email"] , from: self.viewController) { (loginResult, error) in
            
            if loginResult?.isCancelled == true {
                print("cancelled.")
            }
            else {
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                Auth.auth().signIn(with: credential, completion: { (user, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    self.UpdateMailId()
                    print("Login Sucessfully.")
                })
            }
        }
    }
    
    func logout() {
        loginManager.logOut()
        
        do {
            try Auth.auth().signOut()
            
        }catch {
            print("error")
        }
    }
    
    func UpdateMailId (){
        Auth.auth().currentUser?.updateEmail(to: "sreeram888@gmail.com", completion: { (error) in
            if error != nil {
                print(error!)
            }
        })
    }
}
