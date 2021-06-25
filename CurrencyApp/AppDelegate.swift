//
//  AppDelegate.swift
//  CurrencyApp
//
//  Created by Sebastian Niestój on 24/06/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let navCon = UINavigationController()
        let mainView = CurrencyListController()
        navCon.viewControllers = [mainView]
        window!.rootViewController = navCon
        window!.makeKeyAndVisible()
        return true
    }

}

