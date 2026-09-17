//
//  SceneDelegate.swift
//  athmovil-checkout-demo
//
//  Created by GitHub Copilot on 8/18/26.
//

import UIKit
import athmovil_checkout

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        if let incomingURL = connectionOptions.urlContexts.first?.url {
            ATHMPaymentSession.shared.url = incomingURL
        }
    }

    func scene(
        _ scene: UIScene,
        openURLContexts URLContexts: Set<UIOpenURLContext>
    ) {
        guard let incomingURL = URLContexts.first?.url else { return }
        ATHMPaymentSession.shared.url = incomingURL
    }
}
