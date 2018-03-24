//
//  AppDelegate.swift
//  Borisov_Aleksey
//
//  Created by Алексей Борисов on 24.11.2017.
//  Copyright © 2017 Aleksey Borisov. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var session: WCSession?
    var background = Background()
    var shouldUpdateBadge = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.badge]) { [weak self] (granted, error) in
            self?.shouldUpdateBadge = granted
        }
        
        FirebaseApp.configure()
        
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        background.loadBackground(application, completionHandler: completionHandler)
        background.realmFriendsToUserDefaults()
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        background.realmFriendsToUserDefaults()
    }
}

extension AppDelegate: WCSessionDelegate {

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        if message["request"] as? String == "friends" {
            guard let friends = background.friendsToSession() else { return }
            replyHandler(friends)
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
}

