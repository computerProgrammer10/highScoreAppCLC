//
//  AppDelegate.swift
//  foreverGameCLCApp
//
//  Created by DANIEL HUSEBY on 2/25/25.
//

import UIKit
import SpriteKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    
    // use this method for eating banananananananananananananana
    func applicationWillResignActive(_ application: UIApplication) {
        print("shittin time")
        if let view = window?.rootViewController?.view as? SKView
        {
            print("wee")
            if let scene = view.scene as? GameScene {
                print("super wee")
                (window?.rootViewController! as! GameViewController).pauseButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
                scene.isPaused = true
                scene.gamePaused = true
            }
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }


}

