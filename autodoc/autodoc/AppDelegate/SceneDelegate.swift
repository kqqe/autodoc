//
//  SceneDelegate.swift
//  autodoc
//
//  Created by Anatoliy on 19.05.2026.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

//    func scene(
//        _ scene: UIScene,
//        willConnectTo session: UISceneSession,
//        options connectionOptions: UIScene.ConnectionOptions
//    ) {
//        guard let windowScene = scene as? UIWindowScene else { return }
//
//        let window = UIWindow(windowScene: windowScene)
//        let rootVC = UINavigationController(
//            rootViewController: NewsListViewController(
//                viewModel: AppContainer.shared.makeNewsListViewModel()
//            )
//        )
//
//        window.rootViewController = rootVC
//        window.makeKeyAndVisible()
//        self.window = window
//    }
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = TabBarController()
        self.window = window
        window.makeKeyAndVisible()
    }
}
