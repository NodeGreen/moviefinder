//
//  MovieSearchTestView.swift
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

            Divider()

            content
                .background(Color(.systemGroupedBackground))
        }
        .edgesIgnoringSafeArea(.bottom)
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            ProgressView()

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
                MovieRow(movie: movie)
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    MovieSearchView()
}
