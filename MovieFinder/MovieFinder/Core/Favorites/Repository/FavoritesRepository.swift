//
//  FavoritesRepository.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//


import Foundation

final class FavoritesRepository: FavoritesRepositoryProtocol {
    private let repository: CoreDataRepository<FavoriteMovieEntity>

    init(repository: CoreDataRepository<FavoriteMovieEntity> = CoreDataRepository()) {
        self.repository = repository
    }

    func getAll() -> [FavoriteMovie] {
        repository.fetch().map { $0.toDomain() }
    }

    func add(_ movie: FavoriteMovie) {
        let entity = repository.insert()
        entity.fill(from: movie)
        repository.save()
    }

    func remove(_ movie: FavoriteMovie) {
        let predicate = NSPredicate(format: "imdbID == %@", movie.id)
        let results = repository.fetch(predicate: predicate)
        results.forEach { repository.delete($0) }
        repository.save()
    }

    func isFavorite(_ id: String) -> Bool {
        let predicate = NSPredicate(format: "imdbID == %@", id)
        return !repository.fetch(predicate: predicate).isEmpty
    }
}
