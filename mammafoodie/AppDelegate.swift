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
import UserNotifications
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate  {
    
    var window: UIWindow?
    var activityIndicatorView:UIView?
    let gcmMessageIDKey = "gcm.message_id"
    
    var currentUserFirebase:User? //Populate this when user logs in successfully
    var currentUser:MFUser? //Populate this when user logs in successfully and after signup
    var uberAccessTokenHandler: ((_ accessToken:String?)->())?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        _ = DatabaseGateway.sharedInstance
        _ = StripeGateway.shared
        
        IQKeyboardManager.sharedManager().enable = true
        FacebookLoginWorker.setup(application: application, with: launchOptions)
        GMSServices.provideAPIKey("AIzaSyClBLZVKux95EUwkJ2fBIgybRvxQb57nBM")
        
        
        let currentUser = Auth.auth().currentUser

        currentUserFirebase = currentUser
        
//        StripeGateway.shared.createCharge(amount: 1, sourceId: "card_1AiwVjEpXe8xLhlBaH8K9cxA", fromUserId: "eSd3qbFf5leM4g6j2oVej7ZeEGA3", toUserId: "oNi1R4X6KdOS5DSLXtAQa62eD553", completion: { (error) in
//            print("Test")
//        })
        
//        StripeGateway.shared.addPaymentMethod(number: "4000 0000 0000 0077", expMonth: 10, expYear: 2020, cvc: "111", completion: { (string, error) in
//            print("Done")
//        });
        
        //        StripeGateway.shared.createCharge(amount: 100, sourceId: "tok_1AihULJwxdjMNYNIXFZx0wLa", completion: { (error) in
        //            print("Done")
        //        })
        //
        
        
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyBoard.instantiateInitialViewController() as! MFNavigationController
        
        let loginVC = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        if currentUser != nil { //User is already logged in, show home screen
            DatabaseGateway.sharedInstance.getUserWith(userID: currentUser!.uid, { (user) in
                self.currentUser = user
            })
            let homeVC = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            loginVC.navigationController?.pushViewController(homeVC, animated: false)
        }

        
        //Register for Push Notifications
//        let notificationTypes: UNAuthorizationOptions = [.alert, .badge, .sound]
//        let pushNotificationSettings =   UIUserNotificationSettings(types: notificationTypes, categories: nil)
//        application.registerUserNotificationSettings(pushNotificationSettings)
//        application.registerForRemoteNotifications()

        //To get access token
//        UberRushDeliveryWorker.getAuthorizationcode{ token in
//            print(token)
//            
//            UberRushDeliveryWorker.getAccessToken(authorizationCode:token!){ json in
//                print(json["access_token"])
//            }
//        }
      
//        self.window?.rootViewController = navigationController
//        self.window?.makeKeyAndVisible()
  
        return true
    }
    
    func updateToken() {
        if let token = InstanceID.instanceID().token() {
            print("APNs token: \(token)")
            if let currentUser = DatabaseGateway.sharedInstance.getLoggedInUser() {
                DatabaseGateway.sharedInstance.setDeviceToken(token, for: currentUser.id, { (error) in
                    print("Token updated")
                })
            }
        }
    }
    
    func askPermissionForRemoteNotifications(with application: UIApplication) {
        Messaging.messaging().shouldEstablishDirectChannel = true
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
    
    class func shared() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func setHomeViewController() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController: MFNavigationController! = storyBoard.instantiateViewController(withIdentifier: "navHome") as! MFNavigationController
        self.window?.rootViewController = navigationController
        
        let worker = OtherUsersProfileWorker()
        worker.getUserDataWith(userID: currentUserFirebase!.uid) { (user) in
            self.currentUser = user
        }
        
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
    
    //PushNotification delegates
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(userInfo)
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

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        if let currentUser = DatabaseGateway.sharedInstance.getLoggedInUser() {
            DatabaseGateway.sharedInstance.setDeviceToken(fcmToken, for: currentUser.id, { (error) in
                print("Token updated")
            })
        }
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
}
// [END ios_10_message_handling]
