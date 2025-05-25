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
                    emptyState
                } else {
                    favoritesList
                }
            }
            .background(Color.white)
            .navigationTitle("My Favorites")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(item: $selectedMovieID) { imdbID in
                MovieDetailView(imdbID: imdbID)
            }
            .onAppear {
                viewModel.loadFavorites()
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart")
                .font(.system(size: 60, weight: .thin))
                .foregroundStyle(.secondary)
            
            VStack(spacing: 8) {
                Text("No Favorites Yet")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.primary)
                
                Text("Movies you mark as favorites will appear here")
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            VStack(spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 14, weight: .medium))
                    Text("Search for movies")
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundStyle(.blue)
                
                HStack(spacing: 8) {
                    Image(systemName: "heart")
                        .font(.system(size: 14, weight: .medium))
                    Text("Tap the heart icon to add favorites")
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundStyle(.secondary)
            }
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var favoritesList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
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
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
    }
}
