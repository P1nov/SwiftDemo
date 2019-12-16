//
//  AppDelegate.swift
//  KeyManagerDemo
//
//  Created by ma c on 2019/12/9.
//  Copyright © 2019 ma c. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if !UserDefaults.standard.bool(forKey: "isFirstOpen") {
            
            KeyDbService.shared.createKeyStoreTable()
            
            UserDefaults.standard.set(true, forKey: "isFirstOpen")
        }
        
        KeyDbService.shared.setUp()
        
        /*
         初始化分类的初始化方法
         */
        UIScrollView.initializeOnceMethod()
        
        guard #available(iOS 13.0, *) else {
            
            let window = UIWindow.init(frame: UIScreen.main.applicationFrame)
            
            window.rootViewController = EDRootViewController.init()
            
            self.window = window
            
            window.makeKeyAndVisible()
            
            return true
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

