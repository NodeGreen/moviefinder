//
//  MovieError.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//


//
//  MovieError.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//

import Foundation

enum MovieError: LocalizedError {
    case networkUnavailable
    case invalidAPIKey
    case movieNotFound
    case invalidMovieID
    case rateLimitExceeded
    case serverError
    case decodingError
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .networkUnavailable:
            return "Network connection unavailable"
        case .invalidAPIKey:
            return "Invalid API key"
        case .movieNotFound:
            return "Movie not found"
        case .invalidMovieID:
            return "Invalid movie ID"
        case .rateLimitExceeded:
            return "Too many requests"
        case .serverError:
            return "Server error"
        case .decodingError:
            return "Unable to process response"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
    
    var failureReason: String? {
        switch self {
        case .networkUnavailable:
            return "Unable to connect to the movie database"
        case .invalidAPIKey:
            return "The API key is missing or invalid"
        case .movieNotFound:
            return "No movie found with the provided search criteria"
        case .invalidMovieID:
            return "The movie ID format is not valid"
        case .rateLimitExceeded:
            return "API request limit has been exceeded"
        case .serverError:
            return "The movie database server is experiencing issues"
        case .decodingError:
            return "The server response could not be processed"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .networkUnavailable:
            return "Check your internet connection and try again"
        case .invalidAPIKey:
            return "Please check your API key configuration"
        case .movieNotFound:
            return "Try a different search term or movie title"
        case .invalidMovieID:
            return "Please verify the movie ID format"
        case .rateLimitExceeded:
            return "Wait a moment before making another request"
        case .serverError:
            return "Try again later or contact support"
        case .decodingError:
            return "Try again or contact support if the problem persists"
        case .unknown:
            return "Please try again later"
        }
    }
    
    var userFriendlyMessage: String {
        return errorDescription ?? "An unexpected error occurred"
    }
}

extension MovieError {
    static func from(_ error: Error) -> MovieError {
        if let movieError = error as? MovieError {
            return movieError
        }
        
        let errorDescription = error.localizedDescription.lowercased()
        
        if errorDescription.contains("network") || errorDescription.contains("internet") {
            return .networkUnavailable
        } else if errorDescription.contains("not found") || errorDescription.contains("404") {
            return .movieNotFound
        } else if errorDescription.contains("api key") || errorDescription.contains("unauthorized") {
            return .invalidAPIKey
        } else if errorDescription.contains("rate limit") || errorDescription.contains("429") {
            return .rateLimitExceeded
        } else if errorDescription.contains("server") || errorDescription.contains("500") {
            return .serverError
        } else if errorDescription.contains("decoding") || errorDescription.contains("parsing") {
            return .decodingError
        } else {
            return .unknown(error)
        }
    }
}