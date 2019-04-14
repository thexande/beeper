//
//  AppDelegate.swift
//  beeper_example
//
//  Created by Alexander Murphy on 4/13/19.
//  Copyright © 2019 Alexander Murphy. All rights reserved.
//

import UIKit
import beeper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: ViewController())
        window?.makeKeyAndVisible()
        return true
    }
}

