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
        HStack(spacing: 16) {
            AsyncImage(url: posterURL) { phase in
                switch phase {
                case .empty:
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.quaternary)
                        .overlay {
                            Image(systemName: "photo")
                                .foregroundStyle(.secondary)
                                .font(.title2)
                        }
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                case .failure:
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.red.opacity(0.1))
                        .overlay {
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundStyle(.red)
                                .font(.title3)
                        }
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 70, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)

            VStack(alignment: .leading, spacing: 6) {
                Text(movie.title)
                    .font(.system(size: 18, weight: .semibold, design: .default))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(movie.year)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(spacing: 8) {
                Button(action: onToggleFavorite) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(isFavorite ? .red : .secondary)
                        .symbolEffect(.bounce, value: isFavorite)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
        .contentShape(Rectangle())
    }
    
    private var posterURL: URL? {
        guard !movie.poster.isEmpty,
              let encoded = movie.poster.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        return URL(string: encoded)
    }
}

#Preview {
    MovieRow(
        movie: Movie(title: "Inception", year: "2010", poster: "", imdbID: "tt1375666"),
        isFavorite: true,
        onToggleFavorite: {}
    )
    .padding()
}
