//
//  AppDelegate.swift
//  SplashAnimate
//
//  Created by Hanson on 2017/12/6.
//  Copyright © 2017年 HansonStudio. All rights reserved.
//

import UIKit
import React
import React_RCTAppDelegate

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setUpWindowAndRootView()
        
        return true
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
}

extension AppDelegate {
    
    func setUpWindowAndRootView() {
//      let view = ReactViewController()
      let view = ViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.backgroundColor = UIColor.white
        window!.makeKeyAndVisible()
//        
//        let adVC = AdViewController()
      
//        adVC.completion = {
//            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReactViewController") as! ViewController
//            vc.adView = adVC.view
//            self.window!.rootViewController = vc
//        }
//        window!.rootViewController = adVC
//      window!.rootViewController = view
//      RCTBridge.setModuleClass(NativeCommunicationModule.self, forName: "NativeCommunicationModule")
//      RCTBridge.setModuleClass(EventEmitterModule.self, forName: "EventEmitterModule")
      window?.rootViewController = view
//      self.addSubview(view)
    }
}
