//
//  NewsRepository.swift
//  autodoc
//
//  Created by Anatoliy on 19.05.2026.
//

import Foundation

protocol NewsRepositoryProtocol {
    func fetchNews(page: Int, pageSize: Int) async throws -> [NewsItem]
}

final class NewsRepository: NewsRepositoryProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchNews(page: Int, pageSize: Int) async throws -> [NewsItem] {
        guard let url = Endpoint.news(page: page, pageSize: pageSize) else {
            throw NetworkError.invalidURL
        }

        let response: NewsResponseDTO = try await apiClient.fetch(NewsResponseDTO.self, from: url)
        return response.news.map(NewsMapper.map)
    }
}
