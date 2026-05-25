//
//  TabBarViewController.swift
//  autodoc
//
//  Created by Anatoliy on 25.05.2026.
//

import UIKit

final class TabBarController: UITabBarController {
    
    init(
        autoViewController: UIViewController,
        companyViewController: UIViewController,
        settingsViewController: UIViewController
    ) {
        super.init(nibName: nil, bundle: nil)

        let autoNav = UINavigationController(rootViewController: autoViewController)
        autoNav.tabBarItem = UITabBarItem(title: "Авто", image: UIImage(systemName: "car.fill"), tag: 0)

        let companyNav = UINavigationController(rootViewController: companyViewController)
        companyNav.tabBarItem = UITabBarItem(title: "Компании", image: UIImage(systemName: "building.2.fill"), tag: 1)

        let settingsNav = UINavigationController(rootViewController: settingsViewController)
        settingsNav.tabBarItem = UITabBarItem(title: "Настройки", image: UIImage(systemName: "gearshape.fill"), tag: 2)

        viewControllers = [autoNav, companyNav, settingsNav]
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

