//
//  CoreDataService.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//


import CoreData

final class CoreDataService {
    static let shared = CoreDataService()

    let container: NSPersistentContainer

    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MovieFinder")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData loading failed: \(error)")
            }
        }
    }

    var context: NSManagedObjectContext {
        container.viewContext
    }

    func saveContext() {
        guard context.hasChanges else { return }
        try? context.save()
    }
}
