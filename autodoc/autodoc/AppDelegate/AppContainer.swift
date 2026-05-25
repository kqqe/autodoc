//
//  AppContainer.swift
//  autodoc
//
//  Created by Anatoliy on 19.05.2026.
//

import Foundation
import UIKit

final class AppContainer {
    static let shared = AppContainer()
    
    let settingsService = SettingsService()
    private let apiClient = APIClient()
    private let imageLoader = ImageLoader.shared
    
    private init() {}

    func makeNewsAutoScreen() -> UIViewController {
        let repository = NewsRepository(apiClient: apiClient)
        let viewModel = NewsListViewModel(
            repository: repository,
            imageLoader: imageLoader,
            settingsService: settingsService,
            currentCategory: .auto
        )
        let viewController = NewsListViewController(category: .auto, viewModel: viewModel)
        return viewController
    }
    
    func makeNewsCompanyScreen() -> UIViewController {
        let repository = NewsRepository(apiClient: apiClient)
        let viewModel = NewsListViewModel(
            repository: repository,
            imageLoader: imageLoader,
            settingsService: settingsService,
            currentCategory: .company
        )
        let viewController = NewsListViewController(category: .company, viewModel: viewModel)
        return viewController
    }
    
    func makeSettingsScreen() -> UIViewController {
        let viewModel = SettingsViewModel(settingsService: settingsService)
        let viewController = SettingsViewController(viewModel: viewModel)
        return viewController
    }
}
