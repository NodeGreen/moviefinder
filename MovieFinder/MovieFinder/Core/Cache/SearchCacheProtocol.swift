//
//  SearchCacheProtocol.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//


import Foundation

protocol SearchCacheProtocol {
    func save(_ query: String)
    func load() -> [String]
}
