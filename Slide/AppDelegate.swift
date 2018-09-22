//
//  AppDelegate.swift
//  Slide
//
//  Created by LetsNurture on 20/09/16.
//  Copyright © 2016 LetsNurture. All rights reserved.
//

import UIKit
import Intents
let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        INPreferences.requestSiriAuthorization {
            switch $0 {
            case .authorized:
                print("authorized")
                break
                
            case .notDetermined:
                print("notDetermined")
                break
                
            case .restricted:
                print("restricted")
                break
                
            case .denied:
                print("denied")
                break
            }
        }
              
//        if let obj = launchOptions![UIApplicationLaunchOptionsKey.userActivityDictionary] {
//            print(obj)
//        }
        return true
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

        
       
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
          let mymantra1 = UserDefaults(suiteName: "group.letsnurture.siriExample")
         print(mymantra1?.value(forKey: "Siri"))
        if mymantra1?.value(forKey: "Siri") != nil{
            //mymantra1?.removeObject(forKey: "Siri")
            let controller = storyBoard.instantiateViewController(withIdentifier: "CustomNVC") as! CustomNVC
            window?.rootViewController = controller
            
        }

    
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        
        let mymantra1 = UserDefaults(suiteName: "group.letsnurture.siriExample")
        print(mymantra1?.value(forKey: "Siri"))
       
        
        let controller = storyBoard.instantiateViewController(withIdentifier: "parkingVC") as! parkingVC
        window?.rootViewController = controller
        
        
        
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let mymantra1 = UserDefaults(suiteName: "group.letsnurture.siriExample")
        print(mymantra1?.value(forKey: "Siri"))
      
        
        let controller = storyBoard.instantiateViewController(withIdentifier: "parkingVC") as! parkingVC
        window?.rootViewController = controller
        
        
        
        return true

    }
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
      guard let intent = userActivity.interaction?.intent as? INRequestRideIntent else{
        return false
        }
        return true
    }
}

