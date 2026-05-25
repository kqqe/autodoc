//
//  APIClient.swift
//  autodoc
//
//  Created by Anatoliy on 19.05.2026.
//

import Foundation

protocol APIClientProtocol {
    func fetch<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T
}

final class APIClient: APIClientProtocol {
    func fetch<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            print("Response",response)


            guard let httpResponse = response as? HTTPURLResponse else {
                print("=Response",response)
                throw NetworkError.invalidResponse
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                print("httpResponse", httpResponse)
                throw NetworkError.badStatusCode(httpResponse.statusCode)
            }

            do {
                return try JSONDecoder.newsDecoder.decode(T.self, from: data)
            } catch {
                print("data", data)
                throw NetworkError.decoding(error)
            }
        } catch let error as NetworkError {
            print("error", error)
            throw error
        } catch {
            throw NetworkError.transport(error)
        }
    }
}

extension JSONDecoder {
    static var newsDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        return decoder
    }
}
