//
//  ImageLoader.swift
//  autodoc
//
//  Created by Anatoliy on 19.05.2026.
//

import UIKit

protocol ImageLoaderProtocol {
    func image(from url: URL) async throws -> UIImage
}


final class ImageLoader: ImageLoaderProtocol {
    static let shared = ImageLoader()

    private let cache = NSCache<NSURL, UIImage>()
    private var tasks: [URL: Task<UIImage, Error>] = [:]
    private let lock = NSLock()

    func image(from url: URL) async throws -> UIImage {
        if let cached = cache.object(forKey: url as NSURL) {
            return cached
        }

        let task: Task<UIImage, Error> = lock.withLock {
            if let existingTask = tasks[url] {
                return existingTask
            }

            let newTask = Task<UIImage, Error> {
                let (data, response) = try await URLSession.shared.data(from: url)

                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode),
                      let image = UIImage(data: data) else {
                    throw NetworkError.invalidResponse
                }

                return image
            }

            tasks[url] = newTask
            return newTask
        }

        defer {
            lock.withLock {
                tasks[url] = nil
            }
        }

        let image = try await task.value
        cache.setObject(image, forKey: url as NSURL)
        return image
    }
}


