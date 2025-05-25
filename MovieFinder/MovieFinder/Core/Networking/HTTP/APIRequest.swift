//
//  APIRequest.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//


import Foundation

struct APIRequest<Response: Decodable> {
    let endpoint: Endpoint
    let method: HTTPMethod
    let decoder: ResponseDecoder

    init(endpoint: Endpoint,
         method: HTTPMethod = .get,
         decoder: ResponseDecoder = JSONResponseDecoder()) {
        self.endpoint = endpoint
        self.method = method
        self.decoder = decoder
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}
