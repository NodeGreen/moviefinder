//
//  MovieAPIClientProtocol.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//


import Foundation

protocol MovieAPIClientProtocol {
    func searchMovies(query: String, completion: @escaping (Result<[Movie], Error>) -> Void)
    func getMovieDetail(imdbID: String, completion: @escaping (Result<MovieDetail, Error>) -> Void)
}
