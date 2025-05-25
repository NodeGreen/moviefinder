//
//  MovieFinderApp.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//

import SwiftUI

@main
struct MovieFinderApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MovieSearchView()
            }
        }
    }
}
