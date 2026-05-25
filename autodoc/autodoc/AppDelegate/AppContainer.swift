//
//  AppContainer.swift
//  autodoc
//
//  Created by Anatoliy on 19.05.2026.
//

import Foundation

final class AppContainer {
    static let shared = AppContainer()

    private init() {}

    func makeNewsListViewModel() -> NewsListViewModel {
        let apiClient = APIClient()
        let repository = NewsRepository(apiClient: apiClient)
        return NewsListViewModel(repository: repository)
    }
}
