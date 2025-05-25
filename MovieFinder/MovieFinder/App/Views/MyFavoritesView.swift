//
//  MyFavoritesView.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//


import SwiftUI

struct MyFavoritesView: View {
    @StateObject private var viewModel = MyFavoritesViewModel()
    @State private var selectedMovieID: String?

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.favorites.isEmpty {
                    Text("No favorites yet.")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    List {
                        ForEach(viewModel.favorites) { favorite in
                            Button {
                                selectedMovieID = favorite.id
                            } label: {
                                MovieRow(
                                    movie: viewModel.toMovie(favorite),
                                    isFavorite: true,
                                    onToggleFavorite: {
                                        viewModel.remove(favorite)
                                    }
                                )
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("My Favorites")
            .navigationDestination(item: $selectedMovieID) { imdbID in
                MovieDetailView(imdbID: imdbID)
            }
            .onAppear {
                viewModel.loadFavorites()
            }
        }
    }
}
