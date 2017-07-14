//
//  FirebaseLoginWorker.swift
//  mammafoodie
//
//  Created by GoodWorkLabs on 09/06/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class FirebaseLoginWorker:HUDRenderer {
    
    ///Creates a new Firebase user with given credentials and calls back with a status and an errorMessage if any
    
    func signUp(with Credentials: Login.Credentials, completion: @escaping (_ errorMessage:String?)->()){
        
        showActivityIndicator()
        
        Auth.auth().createUser(withEmail: Credentials.email, password: Credentials.password){
            (user, error) in
            
            self.hideActivityIndicator()
            
            if error != nil { //SignUp Failure
                completion(error!.localizedDescription)
            } else if user != nil { //Successful SignUp
                completion(nil)
            }
        }
        
    }
    
    
    ///Logs in to firebase with given credentials and calls back with a status and an errorMessage if any.
    
    func login(with Credentials:Login.Credentials, completion: @escaping (_ errorMessage:String?)->()){
        
        showActivityIndicator()
        
        Auth.auth().signIn(withEmail: Credentials.email, password: Credentials.password){
            (user, error) in
            
            self.hideActivityIndicator()
            
            if error != nil { //Login Failure
                completion(error!.localizedDescription)
            } else if user != nil { //Login Success
                completion(nil)
            }
        }
    }
    
    ///Logs in to firebase with given Auth provider credentials and calls back with a status and an errorMessage if any.
    
    func login(with Credentials:AuthCredential, completion : @escaping (_ errorMessage:String?) -> ()) {
        
        self.showActivityIndicator()
        
        Auth.auth().signIn(with: Credentials) { (user, error) in
            
            self.hideActivityIndicator()
            
            if error != nil { //Login Failure
                completion(error!.localizedDescription)
            } else if user != nil { //Login Success
                completion(nil)
            }
            
        }
    }
    
    func updatePassword(with Credentials:Login.Credentials, completion: @escaping (_ errorMessage:String?)->()){
        
        
        Auth.auth().currentUser?.updatePassword(to: Credentials.password, completion: { (error) in
            
            if error != nil {
                
                
                if let errorCode = AuthErrorCode(rawValue: error!._code){
                    
                    switch errorCode {
                        
                    case .requiresRecentLogin :
                        
                        completion("Please login again to reset your password")
                        
                    default:
                        
                        completion(error?.localizedDescription)
                        
                    }
                    
                }
            }
        })
    }
    
    
    
    func reAuthunticateUser(with Credential:AuthCredential, completion : @escaping (_ errorMessage:String?)->()){
        
        let user = Auth.auth().currentUser
        
        user?.reauthenticate(with: Credential, completion: { (error) in
            if let error = error{
                completion(error.localizedDescription)
            } else {
                completion(nil)
            }
        })
        
    }
    
    func updateEmailAddressTo(email:String, completion: @escaping (_ errorMessage:String?)->()){
        
        Auth.auth().currentUser?.updateEmail(to: email, completion: { (error) in
            
            if error != nil {
                completion(error!.localizedDescription)
            } else {
                completion(nil)
            }
            
        })
    }
    
    
    
    func signOut(_ completion: @escaping (_ errorMessage:String?)->()){
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            completion(nil)
            
        } catch let signOutError as NSError {
            completion(signOutError.localizedDescription)
        }
        
    }
    
}
