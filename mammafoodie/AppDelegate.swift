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
    
    var currentUserFirebase : User? //Populate this when user logs in successfully
    var currentUser : MFUser? //Populate this when user logs in successfully and after signup
    var uberAccessTokenHandler: ((_ accessToken:String?)->())?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        _ = DatabaseGateway.sharedInstance
        _ = StripeGateway.shared
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 30
        
        FacebookLoginWorker.setup(application: application, with: launchOptions)
        GMSServices.provideAPIKey("AIzaSyClBLZVKux95EUwkJ2fBIgybRvxQb57nBM")
        
        let currentUser = Auth.auth().currentUser
        self.currentUserFirebase = currentUser
        
        if let userId = currentUser?.uid {
            DatabaseGateway.sharedInstance.getUserWith(userID: userId) { (loggedInUser) in
                self.currentUser = loggedInUser
            }
        }
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyBoard.instantiateInitialViewController() as! MFNavigationController
        
        if let welcomeVC = navigationController.viewControllers.first as? WelcomeViewController {
            if currentUser != nil {
                //User is already logged in, show home screen
                DatabaseGateway.sharedInstance.getUserWith(userID: currentUser!.uid, { (user) in
                    self.currentUser = user
                })
                let homeVC = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                welcomeVC.navigationController?.pushViewController(homeVC, animated: false)
            }
        }
        
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
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
                print("Uber URL: \(urlString)")
                if let codeRange = urlString.range(of: "code="){
                    let authCode = urlString.substring(from: (codeRange.upperBound))
                    print("Uber AuthCode: \(authCode)")
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
    
    func resizeImage(image: UIImage, imageName: String) {
        let newWidth: CGFloat = 400
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize.init(width: newWidth, height: newHeight))
        image.draw(in: CGRect.init(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let documentsPath = NSTemporaryDirectory()
        let destinationPath = documentsPath.appending("\(imageName).jpg")
        do {
            try UIImageJPEGRepresentation(newImage!, 0.9)!.write(to: URL.init(fileURLWithPath: destinationPath))
        } catch {
            print(error)
        }
        print("filePath: \(destinationPath)")
    }
    
    func createNewsFeed() {
        var feeds = [MFNewsFeed]()
        let actionUser = MFUser.init(id: "sXFOH3QceiPdAbLUflTXrW46yag2", name: "Arjav Lad", picture: "", profileDescription: "")
        let participantUser = MFUser.init(id: "MUIqXL7Q7dcmwuwYIJuJdR1jmh53", name: "Are", picture: "", profileDescription: "")
        
        feeds.append(MFNewsFeed.init(with: actionUser, participantUser: participantUser, activity: .followed, text: "Arjav Lad started following Are", redirectID: participantUser.id))
        
        _ = MFUser.init(id: "637ul29k2Bd8eA5AxCrJeE1MjGj1", name: "Are", picture: "", profileDescription: "")
        
        feeds.append(MFNewsFeed.init(with: actionUser, participantUser: participantUser, activity: .followed, text: "Arjav Lad started following Are", redirectID: participantUser.id))
        
        //        let participantUser1 = MFUser.init(id: "637ul29k2Bd8eA5AxCrJeE1MjGj1", name: "Are", picture: "", profileDescription: "")
        
        feeds.append(MFNewsFeed.init(with: actionUser, participantUser: participantUser, activity: .followed, text: "Arjav Lad started following Are", redirectID: participantUser.id))
        
        //        let participantUser2 = MFUser.init(id: "637ul29k2Bd8eA5AxCrJeE1MjGj1", name: "Are", picture: "", profileDescription: "")
        
        feeds.append(MFNewsFeed.init(with: actionUser, participantUser: participantUser, activity: .followed, text: "Arjav Lad started following Are", redirectID: participantUser.id))
        
        //        let participantUser3 = MFUser.init(id: "637ul29k2Bd8eA5AxCrJeE1MjGj1", name: "Are", picture: "", profileDescription: "")
        
        feeds.append(MFNewsFeed.init(with: actionUser, participantUser: participantUser, activity: .followed, text: "Arjav Lad started following Are", redirectID: participantUser.id))
        
        //        let participantUser4 = MFUser.init(id: "637ul29k2Bd8eA5AxCrJeE1MjGj1", name: "Are", picture: "", profileDescription: "")
        
        feeds.append(MFNewsFeed.init(with: actionUser, participantUser: participantUser, activity: .followed, text: "Arjav Lad started following Are", redirectID: participantUser.id))
        
        //        let participantUser5 = MFUser.init(id: "637ul29k2Bd8eA5AxCrJeE1MjGj1", name: "Are", picture: "", profileDescription: "")
        
        feeds.append(MFNewsFeed.init(with: actionUser, participantUser: participantUser, activity: .followed, text: "Arjav Lad started following Are", redirectID: participantUser.id))
        
        //        let participantUser6 = MFUser.init(id: "637ul29k2Bd8eA5AxCrJeE1MjGj1", name: "Are", picture: "", profileDescription: "")
        
        feeds.append(MFNewsFeed.init(with: actionUser, participantUser: participantUser, activity: .followed, text: "Arjav Lad started following Are", redirectID: participantUser.id))
        
        //        let participantUser7 = MFUser.init(id: "637ul29k2Bd8eA5AxCrJeE1MjGj1", name: "Are", picture: "", profileDescription: "")
        
        feeds.append(MFNewsFeed.init(with: actionUser, participantUser: participantUser, activity: .followed, text: "Arjav Lad started following Are", redirectID: participantUser.id))
        
        //        let participantUser8 = MFUser.init(id: "637ul29k2Bd8eA5AxCrJeE1MjGj1", name: "Are", picture: "", profileDescription: "")
        
        feeds.append(MFNewsFeed.init(with: actionUser, participantUser: participantUser, activity: .followed, text: "Arjav Lad started following Are", redirectID: participantUser.id))
        
        //        let participantUser9 = MFUser.init(id: "637ul29k2Bd8eA5AxCrJeE1MjGj1", name: "Are", picture: "", profileDescription: "")
        
        feeds.append(MFNewsFeed.init(with: actionUser, participantUser: participantUser, activity: .followed, text: "Arjav Lad started following Are", redirectID: participantUser.id))
        
        //        let participantUser10 = MFUser.init(id: "637ul29k2Bd8eA5AxCrJeE1MjGj1", name: "Are", picture: "", profileDescription: "")
        
        feeds.append(MFNewsFeed.init(with: actionUser, participantUser: participantUser, activity: .followed, text: "Arjav Lad started following Are", redirectID: participantUser.id))
        
        //        let participantUser11 = MFUser.init(id: "637ul29k2Bd8eA5AxCrJeE1MjGj1", name: "Are", picture: "", profileDescription: "")
        
        feeds.append(MFNewsFeed.init(with: actionUser, participantUser: participantUser, activity: .followed, text: "Arjav Lad started following Are", redirectID: participantUser.id))
        
        //        let participantUser12 = MFUser.init(id: "637ul29k2Bd8eA5AxCrJeE1MjGj1", name: "Are", picture: "", profileDescription: "")
        
        feeds.append(MFNewsFeed.init(with: actionUser, participantUser: participantUser, activity: .followed, text: "Arjav Lad started following Are", redirectID: participantUser.id))
        
        for feed in feeds {
            DatabaseGateway.sharedInstance.save(feed) { (error) in
                print(error?.localizedDescription ?? "No Error")
            }
        }
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
