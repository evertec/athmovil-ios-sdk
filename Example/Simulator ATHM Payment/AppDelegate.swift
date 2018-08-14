//
//  AppDelegate.swift
//  ATHMPaymentSimulator
//
//  Created by Leonardo Maldonado on 5/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

enum ErrorType: String {
    case requiredURLQueryNotFound
    case malformedURLException
    case decodingJSONException
    case requiredJSONPropertiesNotFound
    case transactionExpired
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func application(_ app: UIApplication, open url: URL, options:
        [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        handleIncomingURL(url: url) { (success, transaction, error) in
            if success {
                guard let transaction = transaction else { return }
                presentResponseScreen(with: transaction)
            } else {
                print(error!)
            }
        }
        
        return true
    }
    
    fileprivate func handleIncomingURL(url: URL, completion: (Bool, Transaction?, ErrorType?) -> Void) {
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            else { completion(false, nil, .malformedURLException); return }
        
        guard let query = components.getQueryItem(named: "transaction_data")
            else { completion(false, nil, .requiredURLQueryNotFound); return }
        
        guard let json = query.value?.toJSON else {
            completion(false, nil, .decodingJSONException); return }
        
        guard let transaction = Transaction(json: json) else {
            completion(false, nil, .requiredJSONPropertiesNotFound); return }
        
        completion(true, transaction, nil)
    }
    
    fileprivate func presentResponseScreen(with transaction: Transaction) {
        let storyboard = UIStoryboard.init(
            name: "ResponseViewController", bundle: nil)
        
        let responseViewController = storyboard
            .instantiateInitialViewController()
            as! ResponseViewController
        
        responseViewController.transaction = transaction
        
        window?.rootViewController = responseViewController
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension String {
    var toJSON: [String: Any]? {
        
        guard let query = self.removingPercentEncoding
            else { return nil }
        
        guard let data = query.data(using: .utf8) else { return nil }
        
        guard let json = try? JSONSerialization.jsonObject(
            with: data, options: .mutableContainers)
            as? [String: Any] else { return nil }
        
        return json
    }
}

extension Dictionary {
    var toJSONString: String? {
        
        guard let data = try? JSONSerialization.data(
            withJSONObject: self,
            options: .prettyPrinted) else { return nil }
        
        let jsonString = String(data: data, encoding:
            String.Encoding.utf8)
        
        return jsonString
    }
}

extension URLComponents {
    func getQueryItem(named name: String) -> URLQueryItem? {
        
        guard let queryItems = self.queryItems else { return nil }
        
        for queryItem in queryItems {
            if queryItem.name == name {
                return queryItem
            }
        }
        
        return nil
    }
}
