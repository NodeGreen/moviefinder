//
//  RecentSearchesView.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//


import SwiftUI

struct RecentSearchesView: View {
    let queries: [String]
    let onTap: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Recent Searches")
                .font(.caption)
                .foregroundColor(.secondary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(queries, id: \.self) { query in
                        Button(action: {
                            onTap(query)
                        }) {
                            Text(query)
                                .font(.footnote)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10)
                        }
                    }
                }
            }
        }
        .padding(.top, 4)
    }
}
