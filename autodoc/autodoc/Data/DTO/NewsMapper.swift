//
//  NewsMapper1.swift
//  autodoc
//
//  Created by Anatoliy on 19.05.2026.
//

import UIKit

enum NewsMapper {
    static func map(_ dto: NewsResponseItemDTO) -> NewsItem {
        NewsItem(
            id: dto.id,
            title: dto.title,
            description: dto.description,
            publishedDate: date(from: dto.publishedDate),
            url: URL(string: dto.url),
            fullUrl: URL(string: dto.fullUrl),
            titleImageUrl: dto.titleImageUrl.flatMap(URL.init(string:)),
            categoryType: dto.categoryType
        )
    }

    private static func date(from string: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: string) ?? ISO8601DateFormatter().date(from: string)
    }
}
