//
//  UserDefaultsStore.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//


import Foundation

final class UserDefaultsStore: KeyValueStoreProtocol {
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func set<T: Codable>(_ value: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(value) {
            defaults.set(data, forKey: key)
        }
    }

    func get<T: Codable>(forKey key: String) -> T? {
        guard let data = defaults.data(forKey: key),
              let decoded = try? JSONDecoder().decode(T.self, from: data) else {
            return nil
        }
        return decoded
    }
}
