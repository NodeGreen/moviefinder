//
//  OMDbEndpoint.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//


import Foundation

enum OMDbEndpoint {
    case search(query: String)
    case detail(imdbID: String)
}

extension OMDbEndpoint: Endpoint {
    var baseURL: URL {
        URL(string: "https://www.omdbapi.com")!
    }

    var path: String {
        return "/" // OMDb non ha path distintivi, usa query string
    }

    var queryItems: [URLQueryItem] {
        let apiKey = Bundle.main.omdbApiKey ?? ""
        var items = [URLQueryItem(name: "apikey", value: apiKey)]

        switch self {
        case .search(let query):
            items.append(URLQueryItem(name: "s", value: query))
        case .detail(let imdbID):
            items.append(URLQueryItem(name: "i", value: imdbID))
        }

        return items
    }
}
