//
//  AppDelegate.swift
//  athmovil-checkout-demo
//
//  Created by Cristopher Bautista on 9/20/19.
//  Copyright © 2019 Evertec. All rights reserved.
//

import UIKit
import athmovil_checkout

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        /// You need set the URL after ATH Movil awake your app. This is necesary for the response.
        /// If you have another deep link our SDK will discard the URL that doesn't containts the ATH Movil response so you don't need extra validations
        ATHMPaymentSession.shared.url = url

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) { }

    func applicationDidEnterBackground(_ application: UIApplication) { }

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}
}

