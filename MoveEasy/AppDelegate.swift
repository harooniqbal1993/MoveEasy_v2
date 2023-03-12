//
//  AppDelegate.swift
//  MoveEasy
//
//  Created by Apple on 09/12/1443 AH.
//

import UIKit
import GoogleMaps
import IQKeyboardManagerSwift
import FirebaseCore
import UserNotifications
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyB4NBNYT0Lj_wlG0SXNubJsQE16OthSOFg")
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("didReceiveRemoteNotification, Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Constants.NotificationObserver.OPEN_TRIPVIEW.value,
                                            object: nil,
                                            userInfo: nil)
        }
    }
    
    // [START receive_message]
    //      func application(_ application: UIApplication,
    //                       didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async
    //        -> UIBackgroundFetchResult {
    //        // If you are receiving a notification message while your app is in the background,
    //        // this callback will not be fired till the user taps on the notification launching the application.
    //        // TODO: Handle data of notification
    //        // With swizzling disabled you must let Messaging know about the message, for Analytics
    //        // Messaging.messaging().appDidReceiveMessage(userInfo)
    //        // Print message ID.
    //        if let messageID = userInfo[gcmMessageIDKey] {
    //          print("Message ID: \(messageID)")
    //        }
    //
    //        // Print full message.
    //        print(userInfo)
    //
    //        return UIBackgroundFetchResult.newData
    //      }
    
    // [END receive_message]
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async
    -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // [START_EXCLUDE]
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("willPresent, Message ID: \(messageID)")
        }
        // [END_EXCLUDE]
        // Print full message.
        print("userInfo : ", userInfo)
        DispatchQueue.main.async {
            
            if let response = userInfo["response"] as? Bool {
                print(response)
                
                if let orderID = userInfo["orderid"] as? String {
                    let dic = ["bookingID": orderID, "response": response] as [String : Any]
                    NotificationCenter.default.post(name: Constants.NotificationObserver.OPEN_RECEIPT_VIEW.value,
                                                    object: nil,
                                                    userInfo: dic)
                }
                return
            }
            
            if let orderID = userInfo["orderid"] as? String {
                let dic = ["bookingID": orderID]
                NotificationCenter.default.post(name: Constants.NotificationObserver.OPEN_TRIPVIEW.value,
                                                object: nil,
                                                userInfo: dic)
            }
        }
        
        // Change this to your preferred presentation option
        return [[.alert, .sound]]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse) async {
//        Defaults.fromBackgroundNotificationBookingID = "2388"
        let userInfo = response.notification.request.content.userInfo
        
        // [START_EXCLUDE]
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        // [END_EXCLUDE]
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print full message.
        print(userInfo)
//        if let notificationData = userInfo as? [String: Any?] {
//            print(notificationData)
//            print(notificationData["response"] as Any)
//            print(notificationData["response"] as! Bool)
//        }
        
//        if let response = userInfo["response"] as? NSNumber,
//           response === kCFBooleanTrue || response === kCFBooleanFalse {
//            if response === kCFBooleanTrue {
//                print("TRUE")
//            } else {
//                print("FALSE")
//            }
//            print("it's bool")
//        } else {
//            print("it's not bool")
//        }
        
        if let response = userInfo["response"] as? Bool {
            print(response)
            Defaults.forgotTimerResponse = response ? "YES" : "NO"
            if let orderID = userInfo["orderid"] as? String {
                NetworkService.shared.getBookingSummary(bookingID: orderID) { result, error in
                    debugPrint(error ?? "")
                    OrderSession.shared.bookingModel = result
                }
            }
            return
        }
        
        if let orderID = userInfo["orderid"] as? String {
            Defaults.fromBackgroundNotificationBookingID = orderID
        }
    }
}

extension AppDelegate: MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        Defaults.deviceToken = fcmToken
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Registered for Apple Remote Notifications")
        Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
    }
}

