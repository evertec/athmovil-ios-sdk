//
//  LoadingView.swift
//  athmovil-checkoutTests
//
//  Created by Ismael Paredes on 12/02/23.
//  Copyright © 2023 Evertec. All rights reserved.
//

import Foundation
import UIKit

public class LoadingView{
    
    private static var window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

    
    static func showLoading() {
        guard let onView = getViewOfCurrentlyViewController() else { return }
        let spinnerView = setSpinnerView()
        let activityView = setActivityIndicatorView()
        DispatchQueue.main.async {
            spinnerView.addSubview(activityView)
            onView.addSubview(spinnerView)
        }
    }
    
    static func removeLoadign(){
        guard let onView = getViewOfCurrentlyViewController() else { return }
        DispatchQueue.main.async {
            hiddenLoadingView(onView: onView)
        }
    }
    
}

extension LoadingView{
    
    private static func hiddenLoadingView(onView: UIView){
        onView.subviews.forEach { (view) in
            if view.tag == 9998{
                guard let activityIndicator = view as? UIActivityIndicatorView else { return }
                activityIndicator.stopAnimating()
            }else if view.tag == 9999{
                view.removeFromSuperview()
            }
        }
    }
    
    private static func setSpinnerView() -> UIView{
        guard let window = window else { return UIView() }
        let spinnerView = UIView.init(frame: window.bounds)
        spinnerView.center = window.center
        spinnerView.backgroundColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.50)
        spinnerView.tag = 9999
        return spinnerView
    }
    
    private static func setActivityIndicatorView() -> UIActivityIndicatorView{
        guard let window = window else { return UIActivityIndicatorView() }
        var activityView: UIActivityIndicatorView
        if #available(iOS 13.0, *) {
            activityView = UIActivityIndicatorView(style: .large)
        } else {
            activityView = UIActivityIndicatorView(style: .whiteLarge)
        }
        activityView.center = window.center
        activityView.startAnimating()
        activityView.tag = 9998
        return activityView
    }
    
    private static func getViewOfCurrentlyViewController() -> UIView?{
        if var topController = window?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController.view
        }else{
            return nil
        }
    }
    
}

    

