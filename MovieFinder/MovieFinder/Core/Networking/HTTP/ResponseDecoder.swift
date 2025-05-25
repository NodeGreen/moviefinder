//
//  ResponseDecoder.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//


import Foundation

protocol ResponseDecoder {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

struct JSONResponseDecoder: ResponseDecoder {
    private let decoder: JSONDecoder

    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }

    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        try decoder.decode(type, from: data)
    }
}
