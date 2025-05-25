//
//  MovieRow.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//


import SwiftUI

struct MovieRow: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(movie.title)
                .font(.headline)
            Text(movie.year)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 6)
    }
}
