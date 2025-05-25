//
//  HTTPClientProtocol.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//


import Foundation

protocol HTTPClientProtocol {
    func send<T>(_ request: APIRequest<T>, completion: @escaping (Result<T, Error>) -> Void)
}

final class HTTPClient: HTTPClientProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func send<T>(_ request: APIRequest<T>, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = request.endpoint.url else {
            completion(.failure(APIError.invalidURL))
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue

        let task = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                return completion(.failure(error))
            }

            guard let data = data else {
                return completion(.failure(APIError.noData))
            }

            do {
                let decoded = try request.decoder.decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
