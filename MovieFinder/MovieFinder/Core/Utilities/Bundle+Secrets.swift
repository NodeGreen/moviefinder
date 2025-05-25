//
//  Bundle+Secrets.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//

import Foundation

extension Bundle {
    var omdbApiKey: String? {
        guard let path = self.path(forResource: "Secrets", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) as? [String: Any] else {
            return nil
        }
        return dict["OMDB_API_KEY"] as? String
    }
}
