//
//  AppDelegate.swift
//  Test Project
//
//  Created by Pivotal on 2017-07-04.
//  Copyright © 2017 Pivotal. All rights reserved.
//

import UIKit
import YelpAPI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let clientGenerator: YLPClientWrapperImpl = YLPClientWrapperImpl()
        let locationManager: LocationManagerImpl = LocationManagerImpl()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainViewController(searchProvider: YelpSearchProviderWrapper(clientGenerator: clientGenerator, locationManager: locationManager), locationManager: locationManager)
        window?.makeKeyAndVisible()
        
        return true
    }
}

