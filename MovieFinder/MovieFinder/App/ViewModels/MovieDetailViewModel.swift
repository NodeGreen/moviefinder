//
//  MovieDetailViewModel.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//

import Foundation

@MainActor
final class MovieDetailViewModel: ObservableObject {
    @Published var movieDetail: MovieDetail?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isFavorite: Bool = false
    
    private let favoritesRepository: FavoritesRepositoryProtocol
    private let imdbID: String
    private let apiClient: MovieAPIClientProtocol
    private var fetchTask: Task<Void, Never>?

    init(imdbID: String,
         apiClient: MovieAPIClientProtocol,
         favoritesRepository: FavoritesRepositoryProtocol = FavoritesRepository()) {
        self.imdbID = imdbID
        self.apiClient = apiClient
        self.favoritesRepository = favoritesRepository
        self.isFavorite = favoritesRepository.isFavorite(imdbID)
    }

    func fetch() {
        guard !imdbID.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Invalid movie ID"
            return
        }
        
        fetchTask?.cancel()
        
        isLoading = true
        errorMessage = nil
        movieDetail = nil

        fetchTask = Task { [weak self] in
            await self?.performFetch()
        }
    }
    
    private func performFetch() async {
        await withCheckedContinuation { continuation in
            apiClient.getMovieDetail(imdbID: imdbID) { [weak self] result in
                Task { @MainActor in
                    guard let self = self else {
                        continuation.resume()
                        return
                    }
                    
                    self.isLoading = false
                    
                    switch result {
                    case .success(let detail):
                        if self.isValidMovieDetail(detail) {
                            self.movieDetail = detail
                            self.errorMessage = nil
                        } else {
                            self.errorMessage = "Movie details are incomplete or invalid"
                        }
                    case .failure(let error):
                        self.errorMessage = self.userFriendlyError(from: error)
                    }
                    
                    continuation.resume()
                }
            }
        }
    }
    
    private func isValidMovieDetail(_ detail: MovieDetail) -> Bool {
        return !detail.title.isEmpty &&
               detail.title != "N/A" &&
               !detail.year.isEmpty &&
               detail.year != "N/A"
    }
    
    private func userFriendlyError(from error: Error) -> String {
        if error.localizedDescription.contains("not found") ||
           error.localizedDescription.contains("404") {
            return "Movie not found"
        } else if error.localizedDescription.contains("network") ||
                  error.localizedDescription.contains("internet") {
            return "Network error. Please check your internet connection."
        } else if error.localizedDescription.contains("timeout") {
            return "Request timed out. Please try again."
        } else {
            return "Unable to load movie details. Please try again later."
        }
    }
    
    func toggleFavorite() {
        guard let movie = movieDetail else { return }

        let favorite = FavoriteMovie(
            id: imdbID,
            title: movie.title,
            year: movie.year,
            poster: movie.poster
        )

        if isFavorite {
            favoritesRepository.remove(favorite)
            isFavorite = false
        } else {
            favoritesRepository.add(favorite)
            isFavorite = true
        }
    }
    
    deinit {
        fetchTask?.cancel()
    }
}
