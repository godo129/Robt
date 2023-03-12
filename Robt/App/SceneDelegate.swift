//
//  SceneDelegate.swift
//  Robt
//
//  Created by hong on 2023/03/11.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var rootCoordinator: RootCoordinator?

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let navigationController = UINavigationController()
        rootCoordinator = RootCoordinator(navigationController: navigationController)
        rootCoordinator?.start()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = rootCoordinator?.navigationController
        window?.makeKeyAndVisible()
    }
}
