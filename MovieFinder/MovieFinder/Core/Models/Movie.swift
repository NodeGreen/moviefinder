//
//  Movie.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//
import Foundation

struct Movie: Codable, Identifiable {
    var id: String { imdbID }
    let title: String
    let year: String
    let poster: String
    let imdbID: String

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case poster = "Poster"
        case imdbID
    }
}
