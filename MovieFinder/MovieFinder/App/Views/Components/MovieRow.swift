//
//  MovieRow.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//

import SwiftUI

struct MovieRow: View {
    let movie: Movie
    let isFavorite: Bool
    let onToggleFavorite: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            posterImage
            
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(movie.year)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            favoriteButton
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.caption)
        }
        .contentShape(Rectangle())
        .padding(.vertical, 6)
    }
    
    private var posterImage: some View {
        Group {
            if let url = validPosterURL {
                CachedAsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } errorView: { error in
                    placeholderImageView
                }
                .frame(width: 60, height: 90)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray4), lineWidth: 0.5)
                )
            } else {
                placeholderImageView
            }
        }
    }
    
    private var placeholderImageView: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color(.systemGray5))
            .frame(width: 60, height: 90)
            .overlay(
                VStack(spacing: 4) {
                    Image(systemName: "film")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    Text("No Image")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            )
    }
    
    private var favoriteButton: some View {
        Button(action: onToggleFavorite) {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .foregroundColor(isFavorite ? .red : .gray)
                .font(.title3)
                .scaleEffect(isFavorite ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isFavorite)
        }
        .buttonStyle(.plain)
    }
    
    private var validPosterURL: URL? {
        guard !movie.poster.isEmpty,
              movie.poster != "N/A",
              let url = URL(string: movie.poster),
              url.scheme?.hasPrefix("http") == true else {
            return nil
        }
        return url
    }
}

#Preview {
    VStack {
        MovieRow(
            movie: Movie(
                title: "The Dark Knight",
                year: "2008",
                poster: "https://m.media-amazon.com/images/M/MV5BMTMxNTMwODM0NF5BMl5BanBnXkFtZTcwODAyMTk2Mw@@._V1_SX300.jpg",
                imdbID: "tt0468569"
            ),
            isFavorite: false,
            onToggleFavorite: {}
        )
        
        MovieRow(
            movie: Movie(
                title: "Movie Without Poster",
                year: "2024",
                poster: "",
                imdbID: "tt123456"
            ),
            isFavorite: true,
            onToggleFavorite: {}
        )
        
        MovieRow(
            movie: Movie(
                title: "Very Long Movie Title That Should Wrap to Multiple Lines",
                year: "2023",
                poster: "invalid_url",
                imdbID: "tt789012"
            ),
            isFavorite: false,
            onToggleFavorite: {}
        )
    }
    .padding()
}
