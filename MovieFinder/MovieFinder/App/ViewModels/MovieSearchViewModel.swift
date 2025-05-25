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
    
    private var currentSearchQuery: String = ""
    private var searchTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()
    
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
            clearResults()
            return
        }
        
        guard trimmed != currentSearchQuery else {
            return
        }
        
        searchTask?.cancel()
        
        currentSearchQuery = trimmed
        isLoading = true
        errorMessage = nil
        
        cache.save(trimmed)
        recentQueries = cache.load()

        searchTask = Task { [weak self] in
            await self?.performSearch(query: trimmed)
        }
    }
    
    private func performSearch(query: String) async {
        await withCheckedContinuation { [weak self] continuation in
            guard let self = self else {
                continuation.resume()
                return
            }
            
            self.apiClient.searchMovies(query: query) { [weak self] result in
                Task { @MainActor [weak self] in
                    guard let self = self else {
                        continuation.resume()
                        return
                    }
                    
                    guard self.currentSearchQuery == query else {
                        continuation.resume()
                        return
                    }
                    
                    self.isLoading = false
                    
                    switch result {
                    case .success(let movies):
                        self.movies = movies
                        self.errorMessage = nil
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                        self.movies = []
                    }
                    
                    continuation.resume()
                }
            }
        }
    }
    
    func searchFromRecent(_ recentQuery: String) {
        query = recentQuery
        search()
    }
    
    private func clearResults() {
        movies = []
        errorMessage = nil
        currentSearchQuery = ""
        searchTask?.cancel()
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
    
    deinit {
        searchTask?.cancel()
        cancellables.removeAll()
    }
}
