//
//  KeyValueStoreProtocol.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//


import Foundation

protocol KeyValueStoreProtocol {
    func set<T: Codable>(_ value: T, forKey key: String)
    func get<T: Codable>(forKey key: String) -> T?
}
