//
//  FavoriteMovie.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//


import Foundation

struct FavoriteMovie: Identifiable, Equatable {
    let id: String
    let title: String
    let year: String
    let poster: String
}
