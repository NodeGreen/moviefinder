//
//  Endpoint.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//


import Foundation

protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension Endpoint {
    var url: URL? {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        components?.path = path
        components?.queryItems = queryItems
        return components?.url
    }
}
