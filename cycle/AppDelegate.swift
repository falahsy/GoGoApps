//
//  AppDelegate.swift
//  cycle
//
//  Created by boy setiawan on 12/08/19.
//  Copyright © 2019 boy setiawan. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var eventID: String = ""
    var flagLetsGo = false
    var flagSos = false
    var flagFinish = false
    
    var navigationController: UINavigationController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        setupRoot()

        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {authorized,error in
            if authorized {
                DispatchQueue.main.async(execute: {
                    application.registerForRemoteNotifications()
                })
            }
        })
        
        return true
    }
    
    //setUp subscription ke cloudkit
    // Note: Ini belum ke sambung sm cloudKit yg di apps ini karena belum di set profile nya
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
    }
    
    func letsGo(eventId: String, completion: @escaping ((CKSubscription?, Error?)->Void)) {
        self.unsubscribeNotification()
        
        let subscription = CKQuerySubscription(recordType: "letsGo", predicate: NSPredicate(format: "eventId == %@", eventId), options: .firesOnRecordCreation)
        
        let info = CKSubscription.NotificationInfo()
        
        info.titleLocalizationKey = "%1$@"
        info.titleLocalizationArgs = ["userId"]
        
        info.alertLocalizationKey = "%1$@"
        info.alertLocalizationArgs = ["message"]
        
        info.shouldBadge = true
        info.soundName = "default"
        
        subscription.notificationInfo = info
        
        CKContainer.default().publicCloudDatabase.save(subscription, completionHandler: completion)
    }
    
    //unsubscribe ke cloudkit
    func unsubscribeNotification() {
        CKContainer.default().publicCloudDatabase.fetchAllSubscriptions(completionHandler: { subscriptions, error in
            if error != nil {
                // failed to fetch all subscriptions, handle error here
                // end the function early
                return
            }
            
            if let subscriptions = subscriptions {
                for subscription in subscriptions {
                    CKContainer.default().publicCloudDatabase.delete(withSubscriptionID: subscription.subscriptionID, completionHandler: { string, error in
                        if(error != nil) {
                            print(error ?? "nil")
                            // deletion of subscription failed, handle error here
                        }
                    })
                }
            }
        })
    }
    
    private func setupRoot() {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        if let window = window {
            if Preference.hasSkippedIntro() && Preference.hasLoggedIn() {
                let homeVC = HomeVC()
                setRoot(window, homeVC)
            } else if Preference.hasSkippedIntro() {
                let loginVC = LoginVC()
                loginVC.isLogin = true
                setRoot(window, loginVC)
            } else {
                let onBoardingVC = OnBoardingVC()
                setRoot(window, onBoardingVC)
            }
            
        }
    }
    
    private func setRoot<T: UIViewController>(_ window: UIWindow, _ vc: T) {
        navigationController = UINavigationController(rootViewController: vc)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}

extension AppDelegate {
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}
