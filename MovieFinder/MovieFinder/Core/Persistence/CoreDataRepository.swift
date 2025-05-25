//
//  CoreDataRepository.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//


import CoreData

final class CoreDataRepository<T: NSManagedObject>: CoreDataRepositoryProtocol {
    typealias Entity = T
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataService.shared.context) {
        self.context = context
    }

    func fetch(predicate: NSPredicate? = nil) -> [T] {
        let request = T.fetchRequest()
        request.predicate = predicate
        request.returnsObjectsAsFaults = false

        return (try? context.fetch(request)) as? [T] ?? []
    }

    func insert() -> T {
        T(context: context)
    }

    func delete(_ object: T) {
        context.delete(object)
    }

    func save() {
        try? context.save()
    }
}
