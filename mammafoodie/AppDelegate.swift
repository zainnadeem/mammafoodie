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
import MBProgressHUD

var navigationBarTintColor: UIColor!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate  {
    
    var window: UIWindow?
    var activityIndicatorView:UIView?
//    let gcmMessageIDKey = "gcm.message_id"
    
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
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyBoard.instantiateInitialViewController() as! MFNavigationController
        
        navigationBarTintColor = navigationController.navigationBar.tintColor
        
        if let _ = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [AnyHashable: Any] {
            print("Launch With options")
        }
        
        if let userId = currentUser?.uid {
            if let welcomeVC = navigationController.viewControllers.first as? WelcomeViewController {
                let hud = MBProgressHUD.showAdded(to: welcomeVC.view, animated: true)
                welcomeVC.collectionViewImages.isHidden = true
                welcomeVC.viewContainer.isHidden = true
                _ = DatabaseGateway.sharedInstance.getUserWith(userID: userId) { (loggedInUser) in
                    DispatchQueue.main.async {
                        self.currentUser = loggedInUser
                        welcomeVC.collectionViewImages.isHidden = false
                        welcomeVC.viewContainer.isHidden = false
                        hud.hide(animated: true)
                        if self.currentUser != nil {
                            let homeVC = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                            welcomeVC.navigationController?.pushViewController(homeVC, animated: false)
                            if let userInfo = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [AnyHashable: Any] {
                                self.handleNotification(userInfo, showAlert: false)
                            }
                        } else {
                            FirebaseLoginWorker().signOut({ (error) in
                                
                            })
                        }
                    }
                }
            }
        }
        
        //        self.saveDishes()
        
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        self.askPermissionForRemoteNotifications(with: UIApplication.shared)
        
        return true
    }
    
    func sendTestNotification(id: String = "Yf5bvIiNSMTxBYK6zSajlFYoXw42") {
        let newID = FirebaseReference.notifications.generateAutoID()
        FirebaseReference.notifications.classReference.child(id).updateChildValues([
            newID : [
                "actionUserId": "luuN75SiCHMWenXTngLlPLeW48a2",
                "participantUserID": id,
                "plainText": "VidUp Test!",
                "redirectId": "-KrUd41c4lXHO_KRBAx5",
                //                "redirectId": "-KrUfiLgyJT-N9DVxGOw", Live Video
                "redirectPath": "Dishes",
                "text": "VidUp Test!",
                "timestamp": 522861129.399
            ]])
    }
    
    func updateToken() {
        if let token = Messaging.messaging().fcmToken {
            if let currentUser = DatabaseGateway.sharedInstance.getLoggedInUser() {
                Messaging.messaging().subscribe(toTopic: "TestNotifications")
                print("Updating user:\(currentUser.id) for Token: \(token)")
                DatabaseGateway.sharedInstance.setDeviceToken(token, for: currentUser.id, { (error) in
                    print("Token: \(token)\n Updated for user: \(currentUser.id)")
                })
            }
        }
    }
    
    func askPermissionForRemoteNotifications(with application: UIApplication) {
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
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("Device Token:" + deviceTokenString)
        Messaging.messaging().apnsToken = deviceToken
        self.updateToken()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Deivce Token:" + error.localizedDescription)
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
        if let navController: UINavigationController = self.window?.rootViewController as? UINavigationController {
            if let liveVideoVC: LiveVideoViewController = navController.topViewController as? LiveVideoViewController {
                if liveVideoVC.liveVideo.accessMode == MFDishMediaAccessMode.owner {
                    liveVideoVC.liveVideo.endTimestamp = Date()
                    let url = URL(string: "https://us-central1-mammafoodie-baf82.cloudfunctions.net/stopLiveVideo?dishId=\(liveVideoVC.liveVideo.id)")!
                    do {
                        let _ = try Data(contentsOf: url, options: Data.ReadingOptions.alwaysMapped)
                        print("App closed and live video ended")
                    } catch {
                        
                    }
                }
            }
        }
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
    
    func handleNotification(_ userInfo: [AnyHashable : Any], showAlert: Bool = true) {
        if let _ = self.currentUser,
            let redirectID = userInfo["redirectId"] as? String,
            let redirectPathString = userInfo["redirectPath"] as? String,
            let redirectpath = FirebaseReference(rawValue: redirectPathString) {
            let appState = UIApplication.shared.applicationState
            print("App State: \(appState.rawValue)")
            
            func handleRequest() {
                switch redirectpath {
                case .users:
                    var type: ProfileType = .othersProfile
                    if let currentUser = DatabaseGateway.sharedInstance.getLoggedInUser() {
                        if currentUser.id == redirectID {
                            type = .ownProfile
                        }
                    }
                    self.showUserProfile(with: type, userid: redirectID)
                    
                case .dishes:
                    self.openDish(with: redirectID)
                    
                default:
                    print("Redirect Path not Handled")
                    print("\nNot Handled notification: \(userInfo)\n")
                }
            }
            if showAlert &&
                appState == .active {
                if let text = ((userInfo["aps"] as? [String: AnyHashable])?["alert"] as? [String: String])?["body"] {
                    self.getCurrentViewController().showAlert("Notification Received", message: text, actionTitles: ["View"], cancelTitle: "Ignore", actionhandler: { (actionhandler, index) in
                        DispatchQueue.main.async {
                            handleRequest()
                        }
                    }, cancelActionHandler: { (action) in
                        
                    })
                } else {
                    print("Notification text is wrong: \(userInfo)")
                }
            } else {
                handleRequest()
            }
        } else {
            print("\nNot Handled notification: \(userInfo)\n")
        }
    }
    
    func openDish(with id: String) {
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        func open(dish: MFDish) {
            if let _ = dish.endTimestamp {
                //Vidup
                if let currentVC = self.getCurrentViewController() as? DealDetailViewController {
                    currentVC.load(new: dish)
                } else if let vidupDetailVC = story.instantiateViewController(withIdentifier: "DealDetailViewController") as? DealDetailViewController {
                    vidupDetailVC.DishId = dish.id
                    vidupDetailVC.userId = dish.user.id
                    vidupDetailVC.dish = dish
                    present(vidupDetailVC)
                }
            } else {
                //Live Video
                if let currentVC = self.getCurrentViewController() as? LiveVideoViewController {
                    currentVC.load(new: dish)
                } else if let liveVideoVC = story.instantiateViewController(withIdentifier: "LiveVideoViewController") as? LiveVideoViewController {
                    liveVideoVC.liveVideo = dish
                    present(liveVideoVC)
                }
            }
        }
        
        func present(_ vc: UIViewController) {
            let nav = UINavigationController.init(rootViewController: vc)
            nav.setNavigationBarHidden(true, animated: false)
            self.checkAndPresent(vc: nav)
        }
        
        _ = DatabaseGateway.sharedInstance.getDishWith(dishID: id) { (dish) in
            if let dish = dish {
                DispatchQueue.main.async {
                    open(dish: dish)
                }
            }
        }
    }
    
    func getCurrentViewController() -> UIViewController {
        if let presented = self.window?.rootViewController?.presentedViewController {
            if let nav = presented as? UINavigationController {
                if let last = nav.viewControllers.last {
                    return last
                }
            }
            return presented
        } else if let nav = self.window!.rootViewController as? UINavigationController {
            if let last = nav.viewControllers.last {
                return last
            }
        }
        return self.window!.rootViewController!
    }
    
    func showUserProfile(with type: ProfileType, userid: String) {
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        if let nav = story.instantiateViewController(withIdentifier: "navUserProfile") as? UINavigationController {
            if let profileVC = nav.viewControllers.first as? OtherUsersProfileViewController {
                //                profileVC.profileType = type
                profileVC.userID = userid
                self.checkAndPresent(vc: nav)
            }
        }
    }
    
    func checkAndPresent(vc: UIViewController) {
        if let presented = self.window?.rootViewController?.presentedViewController {
            if presented is UIAlertController {
                print("Presenting Alert!!")
            } else {
                presented.present(vc, animated: true, completion: {
                    
                })
            }
        } else {
            self.window?.rootViewController?.present(vc, animated: true, completion: {
                
            })
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

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        self.handleNotification(notification.request.content.userInfo)
        print("Will Present")
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        self.handleNotification(response.notification.request.content.userInfo)
        print("Did Receive")
        completionHandler()
    }
}
