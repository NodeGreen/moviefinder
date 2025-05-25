//
//  FavoritesRepositoryProtocol.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//


import Foundation

protocol FavoritesRepositoryProtocol {
    func getAll() -> [FavoriteMovie]
    func add(_ movie: FavoriteMovie)
    func remove(_ movie: FavoriteMovie)
    func isFavorite(_ id: String) -> Bool
}
