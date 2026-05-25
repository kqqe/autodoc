//
//  NewsResponse.swift
//  autodoc
//
//  Created by Anatoliy on 19.05.2026.
//

import Foundation

struct NewsResponseDTO: Decodable {
    let news: [NewsResponseItemDTO]
}

struct NewsResponseItemDTO: Decodable {
    let id: Int
    let title: String
    let description: String
    let publishedDate: String
    let url: String
    let fullUrl: String
    let titleImageUrl: String?
    let categoryType: String
}
