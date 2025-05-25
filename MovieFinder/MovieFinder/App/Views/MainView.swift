//
//  MainView.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            NavigationStack {
                MovieSearchView()
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            HStack(spacing: 8) {
                                Image(systemName: "popcorn.fill")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundStyle(.blue)
                                
                                Text("MovieFinder")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundStyle(.primary)
                            }
                        }
                    }
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }

            NavigationStack {
                MyFavoritesView()
            }
            .tabItem {
                Label("Favorites", systemImage: "heart.fill")
            }
        }
        .tint(.blue)
    }
}

#Preview {
    MainView()
}
