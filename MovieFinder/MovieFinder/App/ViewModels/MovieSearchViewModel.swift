//
//  MovieSearchViewModel.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//


import Foundation
import Combine

@MainActor
final class MovieSearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var movies: [Movie] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var selectedMovieID: String?
    @Published var recentQueries: [String] = []
    @Published var favoriteIDs: Set<String> = []

    private let favoritesRepository: FavoritesRepositoryProtocol
    private let apiClient: MovieAPIClientProtocol
    private let cache: SearchCacheProtocol
    
    init(apiClient: MovieAPIClientProtocol,
         cache: SearchCacheProtocol = SearchCache(),
         favoritesRepository: FavoritesRepositoryProtocol = FavoritesRepository()) {
        self.apiClient = apiClient
        self.cache = cache
        self.favoritesRepository = favoritesRepository
        self.recentQueries = cache.load()
        self.favoriteIDs = Set(favoritesRepository.getAll().map { $0.id })
    }

    func search() {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            movies = []
            return
        }

        isLoading = true
        errorMessage = nil
        cache.save(trimmed)
        recentQueries = cache.load()

        apiClient.searchMovies(query: trimmed) { [weak self] result in
            Task { @MainActor in
                self?.isLoading = false
                switch result {
                case .success(let movies):
                    self?.movies = movies
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.movies = []
                }
            }
        }
    }
    
    func toggleFavorite(for movie: Movie) {
        let favorite = FavoriteMovie(id: movie.imdbID, title: movie.title, year: movie.year, poster: movie.poster)

        if favoriteIDs.contains(favorite.id) {
            favoritesRepository.remove(favorite)
            favoriteIDs.remove(favorite.id)
        } else {
            favoritesRepository.add(favorite)
            favoriteIDs.insert(favorite.id)
        }
    }
    
    func refreshFavorites() {
        favoriteIDs = Set(favoritesRepository.getAll().map { $0.id })
    }
}
