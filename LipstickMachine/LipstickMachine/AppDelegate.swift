//
//  AppDelegate.swift
//  LipstickMachine
//
//  Created by liuyang04 on 2021/11/12.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow.init()
        self.window?.frame = kScreenBounds
        self.window?.backgroundColor = UIColor.white
        self.window?.rootViewController = UIViewController()
        self.window?.makeKeyAndVisible()
        
        preference()
        config()
        return true
    }


}

