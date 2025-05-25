//
//  HTTPClientProtocol.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//

import Foundation

final class HTTPClient: HTTPClientProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func send<T>(_ request: APIRequest<T>, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = request.endpoint.url else {
            completion(.failure(MovieError.invalidMovieID))
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.timeoutInterval = 30

        let task = session.dataTask(with: urlRequest) { [weak self] data, response, error in

            guard self != nil else { return }
            
            if let error = error {
                let movieError = MovieError.from(error)
                return completion(.failure(movieError))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200...299:
                    break
                case 401:
                    return completion(.failure(MovieError.invalidAPIKey))
                case 404:
                    return completion(.failure(MovieError.movieNotFound))
                case 429:
                    return completion(.failure(MovieError.rateLimitExceeded))
                case 500...599:
                    return completion(.failure(MovieError.serverError))
                default:
                    return completion(.failure(MovieError.serverError))
                }
            }

            guard let data = data else {
                return completion(.failure(MovieError.networkUnavailable))
            }

            do {
                let decoded = try request.decoder.decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(MovieError.decodingError))
            }
        }

        task.resume()
    }
}
