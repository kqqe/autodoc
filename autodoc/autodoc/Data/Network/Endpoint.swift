//
//   Endpoint.swift .swift
//  autodoc
//
//  Created by Anatoliy on 19.05.2026.
//

import Foundation

enum Endpoint {
    static func news(page: Int, pageSize: Int) -> URL? {
        URL(string: "https://webapi.autodoc.ru/api/news/\(page)/\(pageSize)")
    }
}
