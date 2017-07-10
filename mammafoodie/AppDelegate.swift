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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        _ = DatabaseGateway.sharedInstance
        IQKeyboardManager.sharedManager().enable = true
        FacebookLoginWorker.setup(application: application, with: launchOptions)
        GMSServices.provideAPIKey("AIzaSyClBLZVKux95EUwkJ2fBIgybRvxQb57nBM")
        
        let currentUser = Auth.auth().currentUser
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController: MFNavigationController!
        
        if currentUser != nil { //User is already logged in, show home screen
            navigationController = storyBoard.instantiateViewController(withIdentifier: "navHome") as! MFNavigationController
        } else {
            navigationController = storyBoard.instantiateViewController(withIdentifier: "navLogin") as! MFNavigationController
        }
        
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

