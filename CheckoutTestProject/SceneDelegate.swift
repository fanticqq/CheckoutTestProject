//
//  SceneDelegate.swift
//  CheckoutTestProject
//
//  Created by Igor Zarubin on 02.11.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.windowScene = windowScene
        let viewController = CardInputAssembly.makeModule()
        let rootViewController = UINavigationController(rootViewController: viewController)
        window.rootViewController = rootViewController
        self.window = window
        self.window?.makeKeyAndVisible()
    }
}

