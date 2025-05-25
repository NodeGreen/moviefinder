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
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    if viewModel.isLoading {
                        VStack(spacing: 20) {
                            ProgressView()
                                .scaleEffect(1.2)
                                .tint(.blue)
                            
                            Text("Loading movie details...")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(.secondary)
                        }
                        .frame(height: geometry.size.height * 0.6)
                        
                    } else if let error = viewModel.errorMessage {
                        VStack(spacing: 16) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(.orange)
                            
                            Text("Something went wrong")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.primary)
                            
                            Text(error)
                                .font(.system(size: 16))
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, 32)
                        .frame(height: geometry.size.height * 0.6)
                        
                    } else if let movie = viewModel.movieDetail {
                        VStack(spacing: 24) {
                            VStack(spacing: 20) {
                                Text(movie.title)
                                    .font(.system(size: 28, weight: .bold, design: .default))
                                    .foregroundStyle(.primary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 20)
                                
                                Button(action: {
                                    viewModel.toggleFavorite()
                                }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                                            .font(.system(size: 16, weight: .semibold))
                                        
                                        Text(viewModel.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                                            .font(.system(size: 16, weight: .semibold))
                                    }
                                    .foregroundStyle(viewModel.isFavorite ? .white : .blue)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .background(
                                        viewModel.isFavorite ?
                                        AnyView(LinearGradient(colors: [.red, .pink], startPoint: .leading, endPoint: .trailing)) :
                                        AnyView(Color.blue.opacity(0.1))
                                    )
                                    .clipShape(Capsule())
                                    .overlay(
                                        Capsule()
                                            .stroke(viewModel.isFavorite ? .clear : .blue.opacity(0.3), lineWidth: 1)
                                    )
                                }
                                .buttonStyle(.plain)
                                .symbolEffect(.bounce, value: viewModel.isFavorite)
                            }
                            .padding(.top, 20)
                            
                            VStack(spacing: 16) {
                                InfoSection(items: [
                                    ("calendar", "Year", movie.year),
                                    ("theatermasks", "Genre", movie.genre),
                                    ("person.circle", "Director", movie.director),
                                    ("star.fill", "IMDb Rating", movie.imdbRating)
                                ])
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Image(systemName: "text.alignleft")
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundStyle(.blue)
                                            .frame(width: 24)
                                        
                                        Text("Plot")
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundStyle(.primary)
                                    }
                                    
                                    Text(movie.plot)
                                        .font(.system(size: 16, weight: .regular))
                                        .foregroundStyle(.primary)
                                        .lineSpacing(4)
                                        .padding(.leading, 32)
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
            }
        }
        .background(Color.white)
        .onAppear {
            viewModel.fetch()
        }
    }
}

struct InfoSection: View {
    let items: [(String, String, String)]
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                InfoRow(iconName: item.0, label: item.1, value: item.2)
                
                if index < items.count - 1 {
                    Divider()
                        .padding(.horizontal, 20)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 20)
    }
}


#Preview {
    MovieDetailView(imdbID: "tt1375666")
}
