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
    private var refreshTask: Task<Void, Never>?

    init(repository: FavoritesRepositoryProtocol = FavoritesRepository()) {
        self.repository = repository
        loadFavorites()
    }

    func loadFavorites() {
        refreshTask?.cancel()
        
        refreshTask = Task { [weak self] in
            let favorites = await Task.detached {
                return await self?.repository.getAll() ?? []
            }.value
            
            await MainActor.run { [weak self] in
                self?.favorites = favorites
            }
        }
    }

    func remove(_ movie: FavoriteMovie) {
        Task { [weak self] in
            await Task.detached {
                await self?.repository.remove(movie)
            }.value
            
            self?.loadFavorites()
        }
    }

    func toMovie(_ favorite: FavoriteMovie) -> Movie {
        Movie(title: favorite.title, year: favorite.year, poster: favorite.poster, imdbID: favorite.id)
    }
    
    deinit {
        refreshTask?.cancel()
    }
}
