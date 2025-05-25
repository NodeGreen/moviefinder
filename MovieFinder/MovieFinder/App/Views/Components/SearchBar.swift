//
//  SearchBar.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//


import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String = "Search..."
    var onSubmit: () -> Void

    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .textFieldStyle(.roundedBorder)
                .padding(.leading)

            Button(action: {
                onSubmit()
            }) {
                Image(systemName: "magnifyingglass")
                    .padding(.horizontal)
            }
        }
        .padding(.vertical, 8)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
