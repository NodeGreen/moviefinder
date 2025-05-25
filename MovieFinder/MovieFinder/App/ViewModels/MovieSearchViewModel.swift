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

    private let apiClient: MovieAPIClientProtocol
    private let cache: SearchCacheProtocol
    
    init(apiClient: MovieAPIClientProtocol, cache: SearchCacheProtocol = SearchCache()) {
        self.apiClient = apiClient
        self.cache = cache
        self.recentQueries = cache.load()
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
}
