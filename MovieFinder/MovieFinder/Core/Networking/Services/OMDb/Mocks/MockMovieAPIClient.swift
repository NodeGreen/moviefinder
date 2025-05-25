//
//  MockMovieAPIClient.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//


import Foundation

final class MockMovieAPIClient: MovieAPIClientProtocol {
    var searchResultToReturn: Result<[Movie], Error> = .success([])
    var detailResultToReturn: Result<MovieDetail, Error> = .failure(MockError.unset)
    
    func searchMovies(query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        completion(searchResultToReturn)
    }
    
    func getMovieDetail(imdbID: String, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        completion(detailResultToReturn)
    }
    
    enum MockError: Error {
        case unset
    }
}

