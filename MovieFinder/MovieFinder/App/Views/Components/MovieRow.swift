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
            if let encoded = movie.poster.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
               let url = URL(string: encoded), !movie.poster.isEmpty {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        Color.gray.opacity(0.3)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    case .failure:
                        Color.red.opacity(0.2)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 60, height: 90)
                .cornerRadius(8)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)
                Text(movie.year)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Button(action: onToggleFavorite) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(isFavorite ? .red : .gray)
            }

            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .contentShape(Rectangle())
        .padding(.vertical, 6)
    }
}

#Preview {
    MovieRow(movie: Movie(title: "test", year: "test", poster: "test", imdbID: "test"), isFavorite: true, onToggleFavorite: {})
}
