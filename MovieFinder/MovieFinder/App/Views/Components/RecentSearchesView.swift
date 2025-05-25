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
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "clock.arrow.circlepath")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.secondary)
                
                Text("Recent Searches")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
                    .tracking(0.5)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(queries, id: \.self) { query in
                        Button(action: {
                            onTap(query)
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 12, weight: .medium))
                                
                                Text(query)
                                    .font(.system(size: 14, weight: .medium))
                                    .lineLimit(1)
                            }
                            .foregroundStyle(.primary)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(.thinMaterial, in: Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(.separator, lineWidth: 0.5)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(.vertical, 8)
    }
}
