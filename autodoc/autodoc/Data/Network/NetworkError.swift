//
//  NetworkError.swift .swift
//  autodoc
//
//  Created by Anatoliy on 19.05.2026.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case badStatusCode(Int)
    case decoding(Error)
    case transport(Error)
}
