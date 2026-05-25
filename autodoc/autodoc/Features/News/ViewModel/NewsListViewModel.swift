//
//  Untitled.swift
//  autodoc
//
//  Created by Anatoliy on 19.05.2026.
//

import Foundation
import Combine
import UIKit

final class NewsListViewModel: ObservableObject {
    @Published private(set) var items: [NewsItem] = []
    @Published var selectedItem: NewsItem?

    private let repository: NewsRepositoryProtocol

    init(repository: NewsRepositoryProtocol) {
        self.repository = repository
    }

    func loadInitial() {
        Task {
            do {
                let news = try await repository.fetchNews(page: 1, pageSize: 15)
                await MainActor.run {
                    self.items = news
                }
            } catch {
                await MainActor.run {
                    self.items = []
                }
                print(error)
            }
        }
    }

    func select(_ item: NewsItem) {
        selectedItem = item
    }
}
