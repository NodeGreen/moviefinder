//
//  MockMovieAPIClient.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//

import Foundation

final class MockMovieAPIClient: MovieAPIClientProtocol {
    var searchResultToReturn: Result<[Movie], Error> = .success([])
    var detailResultToReturn: Result<MovieDetail, Error> = .failure(MockError.notConfigured)
    
    func searchMovies(query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        completion(searchResultToReturn)
    }
    
    func getMovieDetail(imdbID: String, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        completion(detailResultToReturn)
    }
}

extension MockMovieAPIClient {
    enum MockError: LocalizedError {
        case notConfigured
        case networkFailure
        case invalidResponse
        case movieNotFound
        case rateLimitExceeded
        
        var errorDescription: String? {
            switch self {
            case .notConfigured:
                return "Mock API client not properly configured for testing"
            case .networkFailure:
                return "Network connection failed"
            case .invalidResponse:
                return "Invalid response from server"
            case .movieNotFound:
                return "Movie not found"
            case .rateLimitExceeded:
                return "Too many requests. Please try again later"
            }
        }
        
        var failureReason: String? {
            switch self {
            case .notConfigured:
                return "The mock client needs to be configured with test data"
            case .networkFailure:
                return "Unable to connect to the movie database"
            case .invalidResponse:
                return "The server returned an unexpected response"
            case .movieNotFound:
                return "No movie found with the provided ID"
            case .rateLimitExceeded:
                return "API rate limit has been exceeded"
            }
        }
        
        var recoverySuggestion: String? {
            switch self {
            case .notConfigured:
                return "Configure the mock with proper test data"
            case .networkFailure:
                return "Check your internet connection and try again"
            case .invalidResponse:
                return "Try again later or contact support"
            case .movieNotFound:
                return "Verify the movie ID and try again"
            case .rateLimitExceeded:
                return "Wait a moment before making another request"
            }
        }
    }
}
