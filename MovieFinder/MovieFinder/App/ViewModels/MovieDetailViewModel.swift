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

    init(imdbID: String,
         apiClient: MovieAPIClientProtocol,
         favoritesRepository: FavoritesRepositoryProtocol = FavoritesRepository()) {
        self.imdbID = imdbID
        self.apiClient = apiClient
        self.favoritesRepository = favoritesRepository
        self.isFavorite = favoritesRepository.isFavorite(imdbID)
    }

    func fetch() {
        isLoading = true
        errorMessage = nil

        apiClient.getMovieDetail(imdbID: imdbID) { [weak self] result in
            Task { @MainActor in
                self?.isLoading = false
                switch result {
                case .success(let detail):
                    self?.movieDetail = detail
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
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

}
