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
