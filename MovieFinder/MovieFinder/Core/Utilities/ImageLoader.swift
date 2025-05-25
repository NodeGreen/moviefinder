//
//  ImageLoader.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//

import UIKit
import Combine

final class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = false
    @Published var error: Error?
    
    private var url: URL?
    private var cancellable: AnyCancellable?
    private static let cache = NSCache<NSString, UIImage>()
    private static let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10.0
        config.timeoutIntervalForResource = 15.0
        config.urlCache = URLCache(
            memoryCapacity: 50 * 1024 * 1024,  // 50MB memory
            diskCapacity: 100 * 1024 * 1024,   // 100MB disk
            diskPath: "movie_images"
        )
        return URLSession(configuration: config)
    }()
    
    static func configure() {
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024 // 50MB
    }
    
    func load(from url: URL?) {
        guard let url = url else {
            DispatchQueue.main.async { [weak self] in
                self?.image = nil
            }
            return
        }
        
        if self.url == url && image != nil {
            return
        }
        
        self.url = url
        
        let cacheKey = NSString(string: url.absoluteString)
        if let cachedImage = Self.cache.object(forKey: cacheKey) {
            DispatchQueue.main.async { [weak self] in
                self?.image = cachedImage
                self?.isLoading = false
                self?.error = nil
            }
            return
        }
        
        loadFromNetwork(url: url, cacheKey: cacheKey)
    }
    
    private func loadFromNetwork(url: URL, cacheKey: NSString) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = true
            self?.error = nil
        }
        
        cancellable = Self.session.dataTaskPublisher(for: url)
            .map(\.data)
            .compactMap { UIImage(data: $0) }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.error = error
                        self?.image = nil
                    }
                },
                receiveValue: { [weak self] image in
                    // Salva in cache
                    Self.cache.setObject(image, forKey: cacheKey)
                    self?.image = image
                    self?.error = nil
                }
            )
    }
    
    func cancel() {
        cancellable?.cancel()
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = false
        }
    }
    
    deinit {
        cancellable?.cancel()
    }
}
