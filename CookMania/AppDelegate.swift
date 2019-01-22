//
//  AppDelegate.swift
//  CookMania
//
//  Created by Elyes on 11/2/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit
import CoreData
import FBSDKCoreKit
import GoogleSignIn
import Firebase
import UserNotifications
import SwiftKeychainWrapper
import IQKeyboardManagerSwift
import Reachability
import CoreStore
import EasyTipView

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var user:User?
    public static let SERVER_DOMAIN = "http://192.168.1.9:3000"
    let GOOGLE_UID_PREFIX = "g_"
    let FACEBOOK_UID_PREFIX = "f_"
    let gcmMessageIDKey = "gcm.message_id"
    
    let reachability = Reachability()!
    var noConnectionAlert: UIAlertController?

    func setUser(user: User) -> Bool {
        if KeychainWrapper.standard.string(forKey: "cookmania_user_id") != nil{
            KeychainWrapper.standard.removeObject(forKey: "cookmania_user_id")
            KeychainWrapper.standard.removeObject(forKey: "cookmania_user_email")
            KeychainWrapper.standard.removeObject(forKey: "cookmania_user_password")
        }
        if KeychainWrapper.standard.set(user.id!, forKey: "cookmania_user_id") && KeychainWrapper.standard.set(user.email!, forKey: "cookmania_user_email") && KeychainWrapper.standard.set(user.password!, forKey: "cookmania_user_password"){
            self.user = user
            return true
        }
        return false
    }
    
    func initializeCoreStore(){
        let stack = DataStack(xcodeModelName: "CookMania")
        CoreStore.defaultStack = stack
        do {
            try CoreStore.addStorageAndWait()
        }
        catch {
            print("error adding storage to CoreStore")
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
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
        Messaging.messaging().delegate = self
        
        if let userInfo = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [String: AnyObject] {
            let notificationId = userInfo["notif_id"] as? String
            let signInViewController = self.window?.rootViewController as! SignInViewController
            let notificationType = Int(userInfo["notif_type"] as! String)
            
            signInViewController.notification = NotificationWrapper(notificationId: notificationId!, notificationType: notificationType!)
        }
        
        application.registerForRemoteNotifications()

        
        FirebaseApp.configure()
        initializeCoreStore()
        
        noConnectionAlert = UIAlertController(title: "Application can't work offline!", message: "", preferredStyle: .alert)
        
        let controller: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "offlineShoppingListViewController")
        
        reachability.whenReachable = { reachability in
            //controller.dismiss(animated: true, completion: nil)
            var viewToDismiss: UIViewController
            if self.window?.rootViewController?.presentedViewController != nil && self.window?.rootViewController?.presentedViewController == self.noConnectionAlert{
                viewToDismiss = self.noConnectionAlert!
            }else if self.window?.rootViewController?.presentedViewController != nil {
                viewToDismiss = controller
            }else {
                return
            }
            viewToDismiss.dismiss(animated: true, completion: {
                if self.window?.rootViewController?.presentedViewController == nil{
                    let signinViewController = (self.window?.rootViewController as! SignInViewController)
                    signinViewController.checkForLogin()
                }
            })
        }
        reachability.whenUnreachable = { _ in
            DispatchQueue.main.async {
                let currentViewController = self.window?.rootViewController?.presentedViewController
                if currentViewController == nil && KeychainWrapper.standard.string(forKey: "cookmania_user_id") == nil{
                    self.window?.rootViewController?.present(self.noConnectionAlert!, animated: true, completion: nil)
                }else if currentViewController != nil {
                    currentViewController!.present(controller, animated: true, completion: nil)
                }else{
                    self.window?.rootViewController?.present(controller, animated: true, completion: nil)
                }
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
        var preferences = EasyTipView.Preferences()
        preferences.drawing.font = UIFont(name: "Futura-Medium", size: 13)!
        preferences.drawing.backgroundColor = UIColor(red: 33, green: 108, blue: 250)
        preferences.drawing.foregroundColor = UIColor.white
        preferences.drawing.textAlignment = NSTextAlignment.center
        preferences.drawing.arrowPosition = .top
        
        preferences.animating.dismissTransform = CGAffineTransform(translationX: 0, y: -15)
        preferences.animating.showInitialTransform = CGAffineTransform(translationX: 0, y: 15)
        preferences.animating.showInitialAlpha = 0
        preferences.animating.showDuration = 0.5
        preferences.animating.dismissDuration = 0.5
        
        EasyTipView.globalPreferences = preferences
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let googleHandler = GIDSignIn.sharedInstance().handle(url as URL?,
                                                              sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                              annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        let facebookHandler = (FBSDKApplicationDelegate.sharedInstance()?.application(app, open: url, options: options))!
        return facebookHandler || googleHandler
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "CookMania")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    static func getDeviceToken(callback: @escaping (_ token: String) -> ()){
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
                callback("")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                callback(result.token)
            }
        }
    }

}

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
        completionHandler([.alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        /*if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }*/
        
        if(UIApplication.shared.applicationState == .active || UIApplication.shared.applicationState == .inactive){
            let notificationType = Int(userInfo["notif_type"] as! String)
            if(notificationType == NotificationType.followingAddedRecipe || notificationType == NotificationType.experience){
                RecipeService.getInstance().getRecipe(recipeId: Int((userInfo["notif_id"] as? String)!)!, completionHandler: {recipe in
                    if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RecipeDetailsViewController") as? RecipeDetailsViewController {
                        if let window = self.window, let rootViewController = window.rootViewController {
                            let currentController = rootViewController.presentedViewController as? MainTabLayoutViewController
                            let navigationController = currentController?.selectedViewController as? UINavigationController
                            controller.recipe = recipe
                            navigationController?.pushViewController(controller, animated: true)
                        }
                    }
                })
            }else if(notificationType == NotificationType.follower){
                UserService.getInstance().getUser(id: (userInfo["notif_id"] as? String)!, completionHandler: { user in
                    if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController {
                        if let window = self.window, let rootViewController = window.rootViewController {
                            let currentController = rootViewController.presentedViewController as? MainTabLayoutViewController
                            let navigationController = currentController?.selectedViewController as? UINavigationController
                            controller.user = user
                            navigationController?.pushViewController(controller, animated: true)
                        }
                    }
                })
            }
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
    
}

extension AppDelegate: MessagingDelegate{
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Message data: ", remoteMessage.appData)
    }
    
}

