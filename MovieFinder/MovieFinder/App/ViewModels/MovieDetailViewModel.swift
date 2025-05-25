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

    private let imdbID: String
    private let apiClient: MovieAPIClientProtocol

    init(imdbID: String, apiClient: MovieAPIClientProtocol) {
        self.imdbID = imdbID
        self.apiClient = apiClient
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
}
