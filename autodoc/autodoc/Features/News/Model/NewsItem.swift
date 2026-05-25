//
//  NewsItem.swift
//  autodoc
//
//  Created by Anatoliy on 19.05.2026.
//

import Foundation
import UIKit

struct NewsItem: Hashable, Identifiable {
    let id: Int
    let title: String
    let description: String
    let publishedDate: Date?
    let url: URL?
    let fullUrl: URL?
    var titleImageUrl: URL?
    let categoryType: String
    var image: UIImage?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: NewsItem, rhs: NewsItem) -> Bool {
        lhs.id == rhs.id
    }
}
