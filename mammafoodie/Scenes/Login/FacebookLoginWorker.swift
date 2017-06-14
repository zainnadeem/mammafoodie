import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class FacebookLoginWorker {
    var dict : [String : AnyObject]!
    weak var viewController: UIViewController!
    lazy var loginManager = FBSDKLoginManager()
    
    class func setup(application: UIApplication, with launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    class func openURL(_ url: URL, application: UIApplication, source: String, annotation: Any!) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: source , annotation: annotation)
        return handled
    }
    
    
    func login(completion:@escaping (_ errorMessage:String?, _ authCredential:AuthCredential?)->()){
        
        loginManager.logOut()
        
        loginManager.logIn(withReadPermissions:["email", "public_profile"] , from: self.viewController) { (loginResult, error) in
            
            if let error = error {
                completion(error.localizedDescription, nil)
                return
            }
            
            
            if loginResult?.isCancelled == true {
                completion("The login has been cancelled by you. Please login to proceed.", nil)
                return
            }
            
            
            if let loginResult = loginResult , !loginResult.grantedPermissions.contains("email"){
                completion("Please allow the app to access your email and try again", nil)
                return
            } else {
                
                    //Check if email is empty in facebook user profile
                    let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"])
                    
                    request!.start(completionHandler: { (connection, result, error) in
                        if(error == nil)
                        {
                            guard let email = (result as? NSDictionary)?.value(forKey: "email") as? String, email != ""  else {
                                
                                completion("We are unable to retreive your email from facebook. Please provide your email to continue", nil)
                                return
                            }
                            
                        } else {
                            completion(error?.localizedDescription, nil)
                        }

                    })
                
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                completion("Failed to get access token. Please try again.", nil)
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            completion(nil, credential)
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
