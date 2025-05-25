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
            content
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetch()
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            loadingView
        } else if let error = viewModel.errorMessage {
            errorView(error)
        } else if let movie = viewModel.movieDetail {
            movieContentView(movie)
        } else {
            emptyStateView
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            Spacer()
            ProgressView()
                .scaleEffect(1.2)
            Text("Loading movie details...")
                .foregroundColor(.secondary)
                .font(.subheadline)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func errorView(_ error: String) -> some View {
        ScrollView {
            VStack(spacing: 16) {
                Spacer()
                
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 48))
                    .foregroundColor(.orange)
                
                Text("Unable to load movie details")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                
                Text(error)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Button("Try Again") {
                    viewModel.fetch()
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, 8)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: 400)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: "film")
                .font(.system(size: 48))
                .foregroundColor(.gray)
            
            Text("Movie not found")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("The requested movie details could not be found.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Go Back") {
                // Navigation back will be handled by the navigation stack
            }
            .buttonStyle(.bordered)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func movieContentView(_ movie: MovieDetail) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            favoriteButton
                .padding(.horizontal)
                .padding(.bottom, 8)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    movieHeaderView(movie)
                    movieDetailsView(movie)
                    plotView(movie)
                }
                .padding()
            }
        }
    }
    
    private var favoriteButton: some View {
        Button(action: {
            viewModel.toggleFavorite()
        }) {
            HStack {
                Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                Text(viewModel.isFavorite ? "Remove from Favorites" : "Add to Favorites")
            }
            .foregroundColor(viewModel.isFavorite ? .red : .blue)
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    private func movieHeaderView(_ movie: MovieDetail) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(movie.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .lineLimit(nil)
            
            HStack {
                Text(movie.year)
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                if !movie.imdbRating.isEmpty && movie.imdbRating != "N/A" {
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(movie.imdbRating)
                            .fontWeight(.semibold)
                    }
                }
            }
        }
    }
    
    private func movieDetailsView(_ movie: MovieDetail) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            if !movie.genre.isEmpty && movie.genre != "N/A" {
                InfoRow(label: "Genre", value: movie.genre)
            }
            
            if !movie.director.isEmpty && movie.director != "N/A" {
                InfoRow(label: "Director", value: movie.director)
            }
        }
    }
    
    private func plotView(_ movie: MovieDetail) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if !movie.plot.isEmpty && movie.plot != "N/A" {
                Text("Plot")
                    .font(.headline)
                    .padding(.top, 8)
                
                Text(movie.plot)
                    .font(.body)
                    .lineSpacing(4)
            }
        }
    }
}

#Preview {
    NavigationStack {
        MovieDetailView(imdbID: "tt1375666")
    }
}
