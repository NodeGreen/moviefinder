//
//  MovieFinderApp.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//

import SwiftUI

@main
struct MovieFinderApp: App {
    
    init() {
        ImageLoader.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
