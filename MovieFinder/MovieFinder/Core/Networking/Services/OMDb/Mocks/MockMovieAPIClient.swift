//
//  MockMovieAPIClient.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//


import Foundation

final class MockMovieAPIClient: MovieAPIClientProtocol {
    var resultToReturn: Result<[Movie], Error> = .success([])

    func searchMovies(query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        completion(resultToReturn)
    }

    func getMovieDetail(imdbID: String, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        fatalError("Not implemented yet!")
    }
}
