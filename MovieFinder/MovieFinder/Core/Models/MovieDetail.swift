//
//  MovieDetail.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//


import Foundation

struct MovieDetail: Codable {
    let title: String
    let year: String
    let genre: String
    let plot: String
    let director: String
    let imdbRating: String
    let poster: String

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case genre = "Genre"
        case plot = "Plot"
        case director = "Director"
        case imdbRating
        case poster = "Poster"
    }
}
