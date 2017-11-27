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
 var navigationBarBackgroundColor: UIColor!
 var unreadNotificationCount: Int = 0
 let kNotificationReadCount: String = "kNotificationReadCount"
 
 @UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate  {
    
    var window: UIWindow?
    var activityIndicatorView: UIView?
//    let gcmMessageIDKey = "gcm.message_id"
    
    var currentUserFirebase : User? //Populate this when user logs in successfully
    var currentUser : MFUser? //Populate this when user logs in successfully and after signup
    var uberAccessTokenHandler: ((_ accessToken:String?)->())?
    var currentUserObserver: DatabaseConnectionObserver?
    var currentUserStripeVerificationObserver: DatabaseConnectionObserver?
    
    private var notificationObserver: DatabaseConnectionObserver?
    
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
        navigationBarBackgroundColor = navigationController.navigationBar.backgroundColor
        
        if let _ = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [AnyHashable: Any] {
            print("Launch With options")
        }
        
        if let userId = currentUser?.uid {
            
            self.currentUserObserver = DatabaseGateway.sharedInstance.getUserWith(userID: userId, frequency: .realtime) { (loggedInUser) in
                self.currentUser = loggedInUser
            }
            
            if let welcomeVC = navigationController.viewControllers.first as? WelcomeViewController {
                let hud = MBProgressHUD.showAdded(to: welcomeVC.view, animated: true)
                welcomeVC.collectionViewImages.isHidden = true
                welcomeVC.viewContainer.isHidden = true
                _ = DatabaseGateway.sharedInstance.getUserWith(userID: userId) { (loggedInUser) in
                    DispatchQueue.main.async {
                        self.currentUser = loggedInUser
                        self.updateToken()
                        print("Currently logged in user: \(loggedInUser!.id)")
                        welcomeVC.collectionViewImages.isHidden = false
                        welcomeVC.viewContainer.isHidden = false
                        hud.hide(animated: true)
                        if self.currentUser != nil {
                            self.updateNotificationCount()
                            let homeVC = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                            welcomeVC.navigationController?.pushViewController(homeVC, animated: false)
                            if let userInfo = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [AnyHashable: Any] {
                                self.handleNotification(userInfo, shouldTakeAction: true, topViewController: nil, pushNewViewController: false)
                            }
                            self.stripeVerificationCheck()
                        } else {
                            FirebaseLoginWorker().signOut({ (error) in
                                
                            })
                        }
                    }
                }
            }
        }

        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        self.askPermissionForRemoteNotifications(with: UIApplication.shared)
        
//        FirebaseReference.users.classReference.observeSingleEvent(of: .value, with: { (snapshot) in
//            if let users = snapshot.value as? [String: AnyObject] {
//                for (_, value) in users {
//                    if let dict = value as? [String: AnyObject] {
//                        let user = MFUser.init(from: dict)
//                        if user.id != "" {
//                            DatabaseGateway.sharedInstance.updateUserEntity(with: user, { (error) in
//                                print("Error: \(error ?? "nil")")
//                            })
//                        }
//                    }
//                }
//            }
//        })
        return true
    }
    
    func stripeVerificationCheck() {
        guard let userId = self.currentUserFirebase?.uid else {
            print("User is not logged in. Can't check payment gateway verification")
            return
        }
        
        self.currentUserStripeVerificationObserver = DatabaseGateway.sharedInstance.getUserStripeVerificationUpdate(userID: userId, frequency: .realtime, { (stripeVerification) in
            if let sV = stripeVerification {
                self.currentUser?.stripeVerification = sV
                if sV.dueBy != nil {
                    
                    self.isNotificationAlreadyScheduled({ (scheduled) in
                        if scheduled == false {
                            // Ask user to enter the details
                            let alert: UIAlertController = UIAlertController(title: "Account verification", message: "Hey, we need to verify your account. Do you want to start the verification process now?", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (alertAction) in
                                // Open verification controller with required fields
                                self.verifyStripe()
                            }))
                            alert.addAction(UIAlertAction(title: "Later", style: UIAlertActionStyle.cancel, handler: { (alertAction) in
                                // Schedule a local notification after an hour
                                
                                let content = UNMutableNotificationContent()
                                content.title = "Attention"
                                content.body = "Please verify the account to continue sending/receiving tips."
                                content.sound = UNNotificationSound.default()
                                
                                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3600, repeats: false)
                                
                                let request = UNNotificationRequest(identifier: "remindUserToVerifyStripeAccount", content: content, trigger: trigger)
                                UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                                    if let error = error {
                                        print("Could not create notification. Error: \(error)")
                                    }
                                })
                            }))
                            if let navController: UINavigationController = self.window?.rootViewController as? UINavigationController {
                                navController.topViewController?.present(alert, animated: true, completion: nil)
                            }
                        }
                    })
                }
            }
        })
    }
    
    func isNotificationAlreadyScheduled(_ completion: @escaping ((Bool)->Void)) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            var found: Bool = false
            for request in requests {
                if request.identifier == "remindUserToVerifyStripeAccount" {
                    found = true
                }
            }
            completion(found)
        }
    }
    
    func removeNotificationForStripeVerificationReminder() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["remindUserToVerifyStripeAccount"])
    }
    
    //    func sendTestNotification(id: String = "Yf5bvIiNSMTxBYK6zSajlFYoXw42") {
    //        let newID = FirebaseReference.notifications.generateAutoID()
    //        FirebaseReference.notifications.classReference.child(id).updateChildValues([
    //            newID : [
    //                "actionUserId": "luuN75SiCHMWenXTngLlPLeW48a2",
    //                "participantUserID": id,
    //                "plainText": "VidUp Test!",
    //                "redirectId": "-KrUd41c4lXHO_KRBAx5",
    //                //                "redirectId": "-KrUfiLgyJT-N9DVxGOw", Live Video
    //                "redirectPath": "Dishes",
    //                "text": "VidUp Test!",
    //                "timestamp": 522861129.399
    //            ]])
    //    }
    
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
        worker.stopObserver()
        
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
    
    func resizeImage(image: UIImage, width: Double) -> UIImage? {
        let newWidth: CGFloat = CGFloat(width)
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize.init(width: newWidth, height: newHeight))
        image.draw(in: CGRect.init(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func handleNotification(_ userInfo: [AnyHashable : Any], shouldTakeAction: Bool = true, topViewController: UIViewController?, pushNewViewController: Bool) {
        DispatchQueue.main.async {
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
                        self.showUserProfile(with: type, userid: redirectID, topViewController: topViewController)
                        
                    case .dishes:
                        self.openDish(with: redirectID, topViewController: topViewController, pushNewViewController: pushNewViewController)
                        
                    case .dishComments:
                        let comps: [String] = redirectID.components(separatedBy: CharacterSet.init(charactersIn: "/"))
                        if comps.count == 3 {
                            let dishId: String = comps[1]
                            let commentId: String = comps[2]
                            self.openDish(with: dishId, withCommentId: commentId, topViewController: topViewController, pushNewViewController: pushNewViewController)
                        } else {
                            print("Could not find dishId and commentId. Please debug for \(redirectID) in Notifications.")
                        }
                        
                    case .messages:
                        self.openConversation(id: redirectID, topViewController: topViewController, pushNewViewController: pushNewViewController)
                        
                    default:
                        print("Redirect Path not Handled")
                        print("\nNot Handled notification: \(userInfo)\n")
                    }
                }
                
                //            if showAlert &&
                //                appState == .active {
                //                if let text = ((userInfo["aps"] as? [String: AnyHashable])?["alert"] as? [String: String])?["body"] {
                //                    self.getCurrentViewController().showAlert("Notification Received", message: text, actionTitles: ["View"], cancelTitle: "Ignore", actionhandler: { (actionhandler, index) in
                //                        DispatchQueue.main.async {
                //                            handleRequest()
                //                        }
                //                    }, cancelActionHandler: { (action) in
                //
                //                    })
                //                } else {
                //                    print("Notification text is wrong: \(userInfo)")
                //                }
                //            } else {
                
                if shouldTakeAction {
                    handleRequest()
                }
                
                //            }
            } else {
                print("\nNot Handled notification: \(userInfo)\n")
            }
        }
    }
    
    func openDish(with id: String, withCommentId commentId: String? = nil, topViewController: UIViewController?, pushNewViewController: Bool) {
        func open(dish: MFDish, commentId: String? = nil) {
            let story = UIStoryboard.init(name: "Main", bundle: nil)
            if dish.endTimestamp?.timeIntervalSinceReferenceDate ?? 0 > Date().timeIntervalSinceReferenceDate {
                if dish.mediaType == .liveVideo && dish.endTimestamp == nil {
                    if let currentVC = self.getCurrentViewController() as? LiveVideoViewController {
                        currentVC.load(new: dish)
                    } else if let liveVideoVC = story.instantiateViewController(withIdentifier: "LiveVideoViewController") as? LiveVideoViewController {
                        liveVideoVC.liveVideo = dish
                        self.checkAndPresent(vc: liveVideoVC, topViewController: topViewController, pushNewViewController: true)
                    }
                } else if dish.mediaType == .vidup || dish.mediaType == .picture {
                    if let currentVC = self.getCurrentViewController() as? DealDetailViewController {
                        currentVC.commentId = commentId
                        currentVC.load(new: dish, completion: {
                            
                        })
                    } else if let vidupDetailVC = story.instantiateViewController(withIdentifier: "DealDetailViewController") as? DealDetailViewController {
                        vidupDetailVC.commentId = commentId
                        vidupDetailVC.DishId = dish.id
                        vidupDetailVC.userId = dish.user.id
                        vidupDetailVC.dish = dish
                        self.checkAndPresent(vc: vidupDetailVC, topViewController: topViewController, pushNewViewController: true)
                    }
                }
            } else {
                let dishVC: DishDetailViewController = UIStoryboard(name:"DishDetail",bundle:nil).instantiateViewController(withIdentifier: "DishDetailViewController") as! DishDetailViewController
                dishVC.dishID = dish.id
                self.checkAndPresent(vc: dishVC, topViewController: topViewController, pushNewViewController: true)
            }
        }
        
        _ = DatabaseGateway.sharedInstance.getDishWith(dishID: id) { (dish) in
            if let dish = dish {
                DispatchQueue.main.async {
                    open(dish: dish, commentId: commentId)
                }
            }
        }
    }
    
//    func present(_ vc: UIViewController, topViewController: UIViewController?, pushNewViewController: Bool) {
//        let nav = MFNavigationController(rootViewController: vc)
//        nav.setNavigationBarHidden(true, animated: false)
//        self.checkAndPresent(vc: nav, topViewController: topViewController, pushNewViewController: pushNewViewController)
//    }
    
    func openConversation(id: String, topViewController: UIViewController?, pushNewViewController: Bool) {
        DatabaseGateway.sharedInstance.getConversation(with: id) { (conversation) in
            if conversation != nil {
                DispatchQueue.main.async {
                    let storyboard: UIStoryboard = UIStoryboard(name: "Siri",bundle: nil)
                    let destViewController: ChatViewController = storyboard.instantiateViewController(withIdentifier: "ChatVC") as! ChatViewController
                    destViewController.conversation = conversation
                    destViewController.currentUser = self.currentUser
                    self.checkAndPresent(vc: destViewController, topViewController: topViewController, pushNewViewController: pushNewViewController)
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
    
    func showUserProfile(with type: ProfileType, userid: String, topViewController: UIViewController?) {
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        if let nav = story.instantiateViewController(withIdentifier: "navUserProfile") as? UINavigationController {
            if let profileVC = nav.viewControllers.first as? OtherUsersProfileViewController {
                //                profileVC.profileType = type
                profileVC.userID = userid
                nav.navigationBar.tintColor = .darkGray
                if topViewController != nil {
                    self.checkAndPresent(vc: profileVC, topViewController: topViewController, pushNewViewController: true)
                } else {
                    self.checkAndPresent(vc: nav, topViewController: nil, pushNewViewController: false)
                }
            }
        }
    }
    
    func checkAndPresent(vc: UIViewController, topViewController: UIViewController?, pushNewViewController: Bool) {
        
        if let topVC: UIViewController = topViewController {
            if pushNewViewController == true {
                topVC.navigationController?.pushViewController(vc, animated: true)
            } else {
                let navController: MFNavigationController = MFNavigationController(rootViewController: vc)
                navController.setNavigationBarHidden(true, animated: false)
                topVC.navigationController?.present(navController, animated: true, completion: {
                })
            }
        } else {
            if let presented = self.window?.rootViewController?.presentedViewController {
                if presented is UIAlertController {
                    print("Presenting Alert!!")
                } else {
                    presented.present(vc, animated: true, completion: {
                        
                    })
                }
            } else {
                let navController: MFNavigationController = MFNavigationController(rootViewController: vc)
                navController.setNavigationBarHidden(true, animated: false)
                self.window?.rootViewController?.present(navController, animated: true, completion: {
                    
                })
            }
        }
    }
    
    func verifyStripe() {
        print("Verify stripe. ------------- ")
        if let navController: UINavigationController = self.window?.rootViewController as? UINavigationController {
            if let topViewController: UIViewController = navController.topViewController {
                StripeVerificationViewController.presentStripeVerification(on: topViewController, completion: { (submitted) in
                    if submitted {
                        print("Submitted")
                    } else {
                        print("Cancelled")
                    }
                })
            }
        }
    }
 
    func updateNotificationCount() {
        guard let currentUser: MFUser = DatabaseGateway.sharedInstance.getLoggedInUser() else {
            return
        }
        self.notificationObserver = DatabaseGateway.sharedInstance.getNotificationsForUser(userID:currentUser.id, frequency: .realtime) { (nots) in
            var readCount: Int = 0
            if let value: Any = UserDefaults.standard.value(forKey: kNotificationReadCount) {
                readCount = value as! Int
            }
            unreadNotificationCount = (nots.count - readCount)
            DispatchQueue.main.async {
                if self.getCurrentViewController().isKind(of: HomeViewController.self) {
                    let homeVC: HomeViewController = self.getCurrentViewController() as! HomeViewController
                    homeVC.updateNotificationBadgeCount()
                }
            }
        }
    }
    
    func getPaymentNowAllowedMessage() -> String {
        return "You are not allowed to make payments. Please contact us. contact@mammafoodie.com"
    }
    
    class func close(vc: UIViewController) {
        if let navigationController: UINavigationController = vc.navigationController {
            if navigationController.viewControllers.first == vc {
                navigationController.dismiss(animated: true, completion: nil)
            } else {
                navigationController.popViewController(animated: true)
            }
        } else {
            vc.dismiss(animated: true, completion: {
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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //        self.handleNotification(notification.request.content.userInfo, shouldTakeAction: true)
        //        print("Will Present")
        //        completionHandler([.alert,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.notification.request.identifier == "remindUserToVerifyStripeAccount" {
            self.verifyStripe()
        } else {
            self.handleNotification(response.notification.request.content.userInfo, shouldTakeAction: true, topViewController: nil, pushNewViewController: false)
        }
        print("Did Receive")
        completionHandler()
    }
 }
