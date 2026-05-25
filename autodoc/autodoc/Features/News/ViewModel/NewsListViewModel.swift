//
//  Untitled.swift
//  autodoc
//
//  Created by Anatoliy on 19.05.2026.
//

import Foundation
import UIKit
import Combine

@MainActor
final class NewsListViewModel: ObservableObject {
    @Published private(set) var items: [NewsItem] = []
    @Published var selectedItem: NewsItem?
    @Published private(set) var isLoading = false

    private let repository: NewsRepositoryProtocol
    private let imageLoader: ImageLoaderProtocol

    private var currentPage = 1
    private let pageSize = 15
    private var canLoadMore = true

    init(
        repository: NewsRepositoryProtocol,
        imageLoader: ImageLoaderProtocol
    ) {
        self.repository = repository
        self.imageLoader = imageLoader
    }

    func loadInitial() {
        guard !isLoading else { return }
        currentPage = 1
        canLoadMore = true
        items = []
        loadPage(page: currentPage, replace: true)
    }

    func loadNextPageIfNeeded(currentItem: NewsItem) {
        guard canLoadMore, !isLoading else { return }
        guard let lastItem = items.last, lastItem.id == currentItem.id else { return }
        currentPage += 1
        loadPage(page: currentPage, replace: false)
    }

    private func loadPage(page: Int, replace: Bool) {
        isLoading = true

        Task {
            do {
                let news = try await repository.fetchNews(page: page, pageSize: pageSize)

                if news.count < pageSize {
                    canLoadMore = false
                }

                if replace {
                    items = news
                } else {
                    items.append(contentsOf: news)
                }

                await loadImages(for: news)
                isLoading = false
            } catch {
                isLoading = false
                canLoadMore = false
                print(error)
            }
        }
    }

    private func loadImages(for news: [NewsItem]) async {
        var updated = items

        await withTaskGroup(of: (Int, UIImage?).self) { group in
            for item in news {
                group.addTask {
                    guard let url = item.titleImageUrl else { return (item.id, nil) }
                    do {
                        let image = try await self.imageLoader.image(from: url)
                        return (item.id, image)
                    } catch {
                        return (item.id, nil)
                    }
                }
            }

            for await (id, image) in group {
                if let index = updated.firstIndex(where: { $0.id == id }) {
                    updated[index].image = image
                }
            }
        }

        items = updated
    }

    func select(_ item: NewsItem) {
        selectedItem = item
    }
}
