//
//  MovieSearchTestView.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//


import SwiftUI

struct MovieSearchTestView: View {
    @StateObject var viewModel = MovieSearchViewModel(apiClient: MovieAPIClient())

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search for a movie", text: $viewModel.query)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onSubmit {
                        viewModel.search()
                    }

                if viewModel.isLoading {
                    ProgressView()
                }

                if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                }

                List(viewModel.movies) { movie in
                    VStack(alignment: .leading) {
                        Text(movie.title).font(.headline)
                        Text(movie.year).font(.subheadline)
                    }
                }
            }
            .navigationTitle("Movie Finder")
        }
    }
}

#Preview {
    MovieSearchTestView()
}
