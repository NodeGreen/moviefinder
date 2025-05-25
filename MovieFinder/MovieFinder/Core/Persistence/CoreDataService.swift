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
    private let containerQueue = DispatchQueue(label: "CoreDataQueue", qos: .userInitiated)

    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MovieFinder")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.persistentStoreDescriptions.first?.setOption(true as NSNumber,
                                                              forKey: NSPersistentHistoryTrackingKey)
        container.persistentStoreDescriptions.first?.setOption(true as NSNumber,
                                                              forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        
        container.loadPersistentStores { [weak self] _, error in
            if let error = error {
                fatalError("CoreData loading failed: \(error)")
            }
            self?.container.viewContext.automaticallyMergesChangesFromParent = true
        }
    }

    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    func newBackgroundContext() -> NSManagedObjectContext {
        let context = container.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        return context
    }

    func saveContext() {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            context.rollback()
            print("❌ CoreData save failed: \(error)")
        }
    }
    
    func performBackgroundTask<T>(_ block: @escaping (NSManagedObjectContext) -> T) async -> T {
        await withCheckedContinuation { continuation in
            let backgroundContext = newBackgroundContext()
            backgroundContext.perform {
                let result = block(backgroundContext)
                continuation.resume(returning: result)
            }
        }
    }
}
