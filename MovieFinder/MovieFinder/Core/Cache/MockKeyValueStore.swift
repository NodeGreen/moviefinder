//
//  MockKeyValueStore.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//


import Foundation

final class MockKeyValueStore: KeyValueStoreProtocol {
    private var storage: [String: Data] = [:]

    func set<T: Codable>(_ value: T, forKey key: String) {
        storage[key] = try? JSONEncoder().encode(value)
    }

    func get<T: Codable>(forKey key: String) -> T? {
        guard let data = storage[key] else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}
