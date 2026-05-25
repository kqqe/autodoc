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
    @Published private(set) var isPaginationEnabled = true
    @Published private(set) var currentPageIndex = 1
    @Published private(set) var totalPages = 1

    private let repository: NewsRepositoryProtocol
    private let imageLoader: ImageLoaderProtocol
    private let settingsService: SettingsService

    private var allItemsCache: [NewsItem] = []
    private var currentPage = 1
    private let pageSize = 15
    private var canLoadMore = true
    private var currentCategory: NewsCategory?
    private var cancellables = Set<AnyCancellable>()

    init(repository: NewsRepositoryProtocol,
         imageLoader: ImageLoaderProtocol,
         settingsService: SettingsService,
         currentCategory: NewsCategory
    ) {
        self.repository = repository
        self.imageLoader = imageLoader
        self.settingsService = settingsService
        self.currentCategory = currentCategory
        self.isPaginationEnabled = settingsService.isPaginationEnabled
        
        setupBindings()
    }
    
    private func setupBindings() {
        settingsService.$isPaginationEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                self?.handlePaginationModeChange(isEnabled: isEnabled)
            }
            .store(in: &cancellables)
    }

    func loadInitial(category: NewsCategory) {
        guard !isLoading else { return }
        currentCategory = category
        currentPage = 1
        canLoadMore = true
        allItemsCache = []
        items = []
        
        if isPaginationEnabled {
            loadPageForInfiniteScroll(page: currentPage)
        } else {
            loadAllNewsForPagination()
        }
    }

    func loadNextPageIfNeeded(currentItem: NewsItem) {
        guard isPaginationEnabled else { return }
        guard canLoadMore, !isLoading else { return }
        guard let lastItem = items.last, lastItem.id == currentItem.id else { return }
        
        currentPage += 1
        loadPageForInfiniteScroll(page: currentPage)
    }
    
    // MARK: - Pagination Mode (with buttons)
    
    func loadPageForButtons(page: Int) {
        guard !isPaginationEnabled else { return }
        guard page >= 1 && page <= totalPages else { return }
        
        isLoading = true
        currentPageIndex = page
        
        let startIndex = (page - 1) * pageSize
        let endIndex = min(startIndex + pageSize, allItemsCache.count)
        
        if startIndex < allItemsCache.count {
            let pageItems = Array(allItemsCache[startIndex..<endIndex])
            items = pageItems
            
            Task {
                await loadImages(for: pageItems)
                isLoading = false
            }
        } else {
            items = []
            isLoading = false
        }
    }
    
    func loadPreviousPage() {
        loadPageForButtons(page: currentPageIndex - 1)
    }
    
    func loadNextPageForButtons() {
        loadPageForButtons(page: currentPageIndex + 1)
    }
    
    // MARK: - Private Methods
    
    private func handlePaginationModeChange(isEnabled: Bool) {
        guard currentCategory != nil else { return }
        
        isPaginationEnabled = isEnabled
        
        currentPage = 1
        canLoadMore = true
        currentPageIndex = 1
        allItemsCache = []
        
        if isEnabled {
            loadPageForInfiniteScroll(page: 1)
        } else {
            loadAllNewsForPagination()
        }
    }
    
    private func loadPageForInfiniteScroll(page: Int) {
        guard let category = currentCategory else { return }
        
        isLoading = true

        Task {
            do {
                let news = try await repository.fetchNews(page: page, pageSize: pageSize)
                let filteredNews = Self.filteredItems(news, category: category)
                
                await MainActor.run {
                    if page == 1 {
                        self.allItemsCache = filteredNews
                    } else {
                        self.allItemsCache.append(contentsOf: filteredNews)
                    }
                    
                    self.items = self.allItemsCache
                    
                    if news.count < self.pageSize {
                        self.canLoadMore = false
                    }
                    
                    Task {
                        await self.loadImages(for: self.items)
                        self.isLoading = false
                    }
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.canLoadMore = false
                    print("Error loading page \(page): \(error)")
                }
            }
        }
    }
    
    private func loadAllNewsForPagination() {
        guard let category = currentCategory else { return }
        
        isLoading = true
        
        Task {
            do {
                var allNews: [NewsItem] = []
                var currentPage = 1
                var hasMore = true
                
                while hasMore {
                    let news = try await repository.fetchNews(page: currentPage, pageSize: pageSize)
                    let filteredNews = Self.filteredItems(news, category: category)
                    allNews.append(contentsOf: filteredNews)
                    
                    hasMore = news.count == pageSize
                    currentPage += 1
                    
                    if hasMore {
                        try? await Task.sleep(nanoseconds: 100_000_000)
                    }
                }
                
                await MainActor.run {
                    self.allItemsCache = allNews
                    self.totalPages = max(1, Int(ceil(Double(allNews.count) / Double(self.pageSize))))
                    self.loadPageForButtons(page: 1)
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    print("Error loading all news: \(error)")
                }
            }
        }
    }

    private func loadImages(for news: [NewsItem]) async {
        var updated = news

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

        await MainActor.run {
            self.items = updated
        }
    }

    private static func filteredItems(_ items: [NewsItem], category: NewsCategory) -> [NewsItem] {
        items.filter { item in
            switch category {
            case .auto:
                return item.categoryType.contains("Автомобильные новости")
            case .company:
                return item.categoryType.contains("Новости компании")
            }
        }
    }

    func select(_ item: NewsItem) {
        selectedItem = item
    }
}
