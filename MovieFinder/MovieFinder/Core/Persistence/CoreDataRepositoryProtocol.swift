//
//  CoreDataRepositoryProtocol.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//


import CoreData

protocol CoreDataRepositoryProtocol {
    associatedtype Entity: NSManagedObject

    func fetch(predicate: NSPredicate?) -> [Entity]
    func insert() -> Entity
    func delete(_ object: Entity)
    func save()
}
