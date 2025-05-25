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

    private let apiClient: MovieAPIClientProtocol

    init(apiClient: MovieAPIClientProtocol) {
        self.apiClient = apiClient
    }

    func search() {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            movies = []
            return
        }

        isLoading = true
        errorMessage = nil

        apiClient.searchMovies(query: query) { [weak self] result in
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
