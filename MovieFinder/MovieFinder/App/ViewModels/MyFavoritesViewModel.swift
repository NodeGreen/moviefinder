//
//  MyFavoritesViewModel.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//


import Foundation

@MainActor
final class MyFavoritesViewModel: ObservableObject {
    @Published var favorites: [FavoriteMovie] = []

    private let repository: FavoritesRepositoryProtocol

    init(repository: FavoritesRepositoryProtocol = FavoritesRepository()) {
        self.repository = repository
        loadFavorites()
    }

    func loadFavorites() {
        favorites = repository.getAll()
    }

    func remove(_ movie: FavoriteMovie) {
        repository.remove(movie)
        loadFavorites()
    }

    func toMovie(_ favorite: FavoriteMovie) -> Movie {
        Movie(title: favorite.title, year: favorite.year, poster: favorite.poster, imdbID: favorite.id)
    }
}
