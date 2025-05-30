//
//  MovieSearchView.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//

import SwiftUI

struct MovieSearchView: View {
    @StateObject var viewModel = MovieSearchViewModel(apiClient: MovieAPIClient())

    var body: some View {
        VStack(spacing: 0) {
            SearchBar(text: $viewModel.query, placeholder: "Search movies") {
                viewModel.search()
            }
            .padding(.vertical, 8)
            .background(Color(.systemBackground))
            .zIndex(1)
            
            if !viewModel.recentQueries.isEmpty {
                RecentSearchesView(queries: viewModel.recentQueries) { tappedQuery in
                    viewModel.searchFromRecent(tappedQuery)
                }
                .padding(.horizontal)
            }

            Divider()

            content
                .background(Color(.systemGroupedBackground))
        }
        .onAppear {
            viewModel.refreshFavorites()
        }
        .navigationDestination(
            item: Binding(
                get: { viewModel.selectedMovieID },
                set: { viewModel.selectedMovieID = $0 }
            )
        ) { imdbID in
            MovieDetailView(imdbID: imdbID)
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            VStack {
                Spacer()
                ProgressView()
                Spacer()
            }
        } else if let error = viewModel.errorMessage {
            ScrollView {
                VStack(spacing: 8) {
                    Text("⚠️ \(error)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .frame(maxWidth: .infinity)
            }
        } else if viewModel.movies.isEmpty {
            ScrollView {
                VStack {
                    Spacer()
                    Text("No results")
                        .foregroundColor(.gray)
                        .padding()
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
        } else {
            List(viewModel.movies) { movie in
                Button {
                    viewModel.selectedMovieID = movie.imdbID
                } label: {
                    MovieRow(
                        movie: movie,
                        isFavorite: viewModel.favoriteIDs.contains(movie.imdbID),
                        onToggleFavorite: {
                            viewModel.toggleFavorite(for: movie)
                        }
                    )
                }
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    MovieSearchView(viewModel: MovieSearchViewModel(apiClient: MockMovieAPIClient()))
}
