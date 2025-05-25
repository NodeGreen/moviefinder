//
//  MovieDetailView.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//


import SwiftUI

struct MovieDetailView: View {
    @StateObject private var viewModel: MovieDetailViewModel

    init(imdbID: String, apiClient: MovieAPIClientProtocol = MovieAPIClient()) {
        _viewModel = StateObject(wrappedValue: MovieDetailViewModel(imdbID: imdbID, apiClient: apiClient))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else if let movie = viewModel.movieDetail {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(movie.title)
                            .font(.title)
                            .bold()

                        InfoRow(label: "Year", value: movie.year)
                        InfoRow(label: "Genre", value: movie.genre)
                        InfoRow(label: "Director", value: movie.director)
                        InfoRow(label: "IMDb", value: movie.imdbRating)

                        Text(movie.plot)
                            .font(.body)
                            .padding(.top, 8)
                    }
                    .padding()
                }
            } else {
                EmptyView()
            }
        }
        .onAppear {
            viewModel.fetch()
        }
    }
}

#Preview {
    MovieDetailView(imdbID: "tt1375666")
}
