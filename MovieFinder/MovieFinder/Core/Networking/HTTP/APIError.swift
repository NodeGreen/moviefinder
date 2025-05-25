//
//  APIError.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case noData
    case invalidResponse
    case decodingFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .invalidResponse:
            return "Invalid server response"
        case .decodingFailed:
            return "Failed to decode response"
        }
    }
}
