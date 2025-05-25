//
//  FavoriteMovieEntity+Mapper.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//

import Foundation

extension FavoriteMovieEntity {
    func toDomain() -> FavoriteMovie {
        FavoriteMovie(
            id: imdbID ?? "",
            title: title ?? "",
            year: year ?? "",
            poster: poster ?? ""
        )
    }

    func fill(from movie: FavoriteMovie) {
        self.imdbID = movie.id
        self.title = movie.title
        self.year = movie.year
        self.poster = movie.poster
    }
}
