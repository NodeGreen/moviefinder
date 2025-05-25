//
//  MovieAPIClient.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//


import Foundation

final class MovieAPIClient: MovieAPIClientProtocol {
    private let httpClient: HTTPClientProtocol

    init(httpClient: HTTPClientProtocol = HTTPClient()) {
        self.httpClient = httpClient
    }

    func searchMovies(query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let request = APIRequest(endpoint: OMDbEndpoint.search(query: query))
        httpClient.send(request) { (result: Result<SearchResult, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.Search))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getMovieDetail(imdbID: String, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        let request = APIRequest(endpoint: OMDbEndpoint.detail(imdbID: imdbID))
        httpClient.send(request, completion: completion)
    }
}
