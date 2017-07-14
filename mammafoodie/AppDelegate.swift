//
//  AppDelegate.swift
//  mammafoodie
//
//  Created by Zain Nadeem on 6/7/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate  {
    
    var window: UIWindow?
    var activityIndicatorView:UIView?
    
    var uberAccessTokenHandler: ((_ accessToken:String?)->())?
    
    var currentUserFirebase:User? //Populate this when user logs in successfully
    
    var currentUser:MFUser?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        _ = DatabaseGateway.sharedInstance
        IQKeyboardManager.sharedManager().enable = true
        FacebookLoginWorker.setup(application: application, with: launchOptions)
        GMSServices.provideAPIKey("AIzaSyClBLZVKux95EUwkJ2fBIgybRvxQb57nBM")
        
        let currentUser = Auth.auth().currentUser
        currentUserFirebase = currentUser

        let storyBoard = UIStoryboard(name: "Siri", bundle: nil)
        let navigationController = storyBoard.instantiateInitialViewController() as! MFNavigationController
        
        let loginVC = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        if currentUser != nil { //User is already logged in, show home screen
            DatabaseGateway.sharedInstance.getUserWith(userID: currentUser!.uid, { (user) in
                self.currentUser = user
            })
            let homeVC = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            loginVC.navigationController?.pushViewController(homeVC, animated: false)
        }

        //To get access token
//        UberRushDeliveryWorker.getAuthorizationcode{ token in
//            print(token)
//            
//            UberRushDeliveryWorker.getAccessToken(authorizationCode:token!){ json in
//                print(json["access_token"])
//            }
//        }
      
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
  
        return true
        
    }
    
    class func shared() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func setHomeViewController() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController: MFNavigationController! = storyBoard.instantiateViewController(withIdentifier: "navHome") as! MFNavigationController
        self.window?.rootViewController = navigationController
    }
    
    func setLoginViewController() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController: MFNavigationController! = storyBoard.instantiateViewController(withIdentifier: "navLogin") as! MFNavigationController
        self.window?.rootViewController = navigationController
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            
            //For uber rush 
            if url.scheme == "mammafoodie-uber" {
                let urlString = url.relativeString
                
                print(urlString)
                
                if let codeRange = urlString.range(of: "code="){
                    let authCode = urlString.substring(from: (codeRange.upperBound))
                    print(authCode)
                    uberAccessTokenHandler!(authCode)
                    return true
                } else {
                    print("We could not get your authorization code from uber. Please try again.")
                    uberAccessTokenHandler!(nil)
                    return false
                }
            }
            
            
            
            let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
            
            
            let source = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String
            let annotation = options[UIApplicationOpenURLOptionsKey.annotation]
            
            
            return FacebookLoginWorker.openURL(url, application: application, source: source, annotation: annotation) || GmailLoginWorker.canApplicationOpenURL(url, sourceApplication: sourceApplication)
            
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
}

