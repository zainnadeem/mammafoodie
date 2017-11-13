import UIKit
import SafariServices

protocol LoginInteractorInput {
    func signUpWith(credentials:Login.Credentials)
    func loginWith(credentials:Login.Credentials)
    func loginWithGoogle()
    func loginWithFacebook()
    func logout()
    func forgotpasswordWorker(email: String)
}

protocol LoginInteractorOutput {
    func signUpCompletion(errorMessage:String?)
    func loginCompletion(errorMessage:String?)
    func forgotpasswordCompletion(errorMessage:String?)
    func logoutCompletion(errorMessage:String?)
    func viewControllerToPresent() -> UIViewController
}

class LoginInteractor: NSObject, LoginInteractorInput {
    
    var output: LoginInteractorOutput!
    lazy var gmailWorker = GmailLoginWorker()
    lazy var forgotPassWorker = ForgotPasswordWorker()
    
    //Passing Email From View
    func forgotpasswordWorker(email: String) {
        print(email)
        forgotPassWorker.callApI(email: email) { (errorMessage) in
            //print(email)
            self.output.forgotpasswordCompletion(errorMessage:errorMessage)
        }
        
    }
    
    // MARK: - Business logic
    
    
    //MARK: - Input
    
    //Firebase Signup and Login
    func signUpWith(credentials:Login.Credentials) {
        let fireBaseLoginWorker = FirebaseLoginWorker()
        fireBaseLoginWorker.signUp(with: credentials) { (errorMessage) in
            self.output.signUpCompletion(errorMessage: errorMessage)
        }
        
    }
    
    func loginWith(credentials:Login.Credentials) {
        let fireBaseLoginWorker = FirebaseLoginWorker()
        fireBaseLoginWorker.login(with: credentials) { (errorMessage) in
            self.output.loginCompletion(errorMessage: errorMessage)
        }
    }
    
    //Facebook Login
    func loginWithFacebook() {
        let facebookLoginWorker = FacebookLoginWorker()
        facebookLoginWorker.viewController = self.output.viewControllerToPresent()
        facebookLoginWorker.login { (errorMessage, authCredential, email, name) in
            if let error = errorMessage {
                self.output.loginCompletion(errorMessage: error)
            } else if let authCredential = authCredential {
                //If facebook login is successful, login to firebase using facebook auth credential
                let fireBaseLoginWorker = FirebaseLoginWorker()
                fireBaseLoginWorker.login(with: authCredential, completion: { (errorMessage) in
                    if let error = errorMessage {
                        self.output.loginCompletion(errorMessage: error)
                    } else {
                        if let user = AppDelegate.shared().currentUser,
                            let email = email,
                            let name = name {
                            if user.name == "" ||
                                user.name.isEmpty {
                                user.name = name
                            }
                            if user.email == "" ||
                                user.email.isEmpty {
                                user.email = email
                            }
                            DatabaseGateway.sharedInstance.updateUserEntity(with: user, { (error) in
                                DispatchQueue.main.async {
                                    self.output.loginCompletion(errorMessage: nil) //Login Successful
                                }
                            })
                        } else {
                            self.output.loginCompletion(errorMessage: "Login Failed!")
                        }
                    }
                })
            }
        }
        
    }
    
    //Google Login
    func loginWithGoogle() {
        self.gmailWorker.viewController = self.output.viewControllerToPresent()
        self.gmailWorker.signIn { (errorMessage, authCredential, email, name) in
            if let error = errorMessage {
                self.output.loginCompletion(errorMessage: error)
            } else if let authCredential = authCredential {
                //If facebook login is successful, login to firebase using gmail auth credential
                let fireBaseLoginWorker = FirebaseLoginWorker()
                fireBaseLoginWorker.login(with: authCredential, completion: { (errorMessage) in
                    if let error = errorMessage{
                        self.output.loginCompletion(errorMessage: error)
                    } else {
                        if let user = AppDelegate.shared().currentUser,
                            let email = email,
                            let name = name {
                            if user.name == "" ||
                                user.name.isEmpty {
                                user.name = name
                            }
                            if user.email == "" ||
                                user.email.isEmpty {
                                user.email = email
                            }
                            DatabaseGateway.sharedInstance.updateUserEntity(with: user, { (error) in
                                DispatchQueue.main.async {
                                    self.output.loginCompletion(errorMessage: nil) //Login Successful
                                }
                            })
                        } else {
                            self.output.loginCompletion(errorMessage: "Login Failed!")
                        }
                    }
                })
            }
        }
        
    }
    
    //logout
    func logout() {
        let fireBaseLoginWorker = FirebaseLoginWorker()
        fireBaseLoginWorker.signOut { (errorMessage) in
            self.output.logoutCompletion(errorMessage: errorMessage)
        }
        
    }
    
}
