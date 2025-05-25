//
//  SearchCache.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//


import Foundation

final class SearchCache: SearchCacheProtocol {
    private let key = "recent_searches"
    private let limit = 5
    private let store: KeyValueStoreProtocol

    init(store: KeyValueStoreProtocol = UserDefaultsStore()) {
        self.store = store
    }

    func save(_ query: String) {
        var current = load().filter { $0.lowercased() != query.lowercased() }
        current.insert(query, at: 0)
        if current.count > limit {
            current = Array(current.prefix(limit))
        }
        store.set(current, forKey: key)
    }

    func load() -> [String] {
        store.get(forKey: key) ?? []
    }
}
