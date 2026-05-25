//
//  TabBarViewController.swift
//  autodoc
//
//  Created by Anatoliy on 25.05.2026.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let news = UINavigationController(
            rootViewController: NewsListViewController(
                viewModel: AppContainer.shared.makeNewsListViewModel()
            )
        )
        news.tabBarItem = UITabBarItem(title: "Авто новости", image: UIImage(systemName: "newspaper"), tag: 0)

        let favorites = UINavigationController(rootViewController: PlaceholderViewController(titleText: "Избранное", color: .systemYellow))
        favorites.tabBarItem = UITabBarItem(title: "Новости компании", image: UIImage(systemName: "star"), tag: 1)

        let profile = UINavigationController(rootViewController: PlaceholderViewController(titleText: "Профиль", color: .systemBlue))
        profile.tabBarItem = UITabBarItem(title: "Настройки", image: UIImage(systemName: "person"), tag: 2)

        viewControllers = [news, favorites, profile]
    }
}
