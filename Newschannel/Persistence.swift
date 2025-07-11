//
//  Persistence.swift
//  Newschannel
//
//  Created by apple on 10/07/25.
//
import CoreData

import CoreData

class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Newschannel") // Make sure this matches your .xcdatamodeld name

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                print("❌ Core Data failed to load:")
                print("Error: \(error.localizedDescription)")
                print("Reason: \(error.localizedFailureReason ?? "Unknown")")
                print("Suggestion: \(error.localizedRecoverySuggestion ?? "None")")
                print("UserInfo: \(error.userInfo)")
                
                // Fallback to in-memory store during development
                #if DEBUG
                print("⚠️ Falling back to in-memory store for development")
                self.container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
                self.container.loadPersistentStores { _, _ in }
                #else
                fatalError("Unresolved error \(error), \(error.userInfo)")
                #endif
            }
        }

        // ✅ Automatically merge changes from parent contexts
        container.viewContext.automaticallyMergesChangesFromParent = true

        // ✅ Set a merge policy to avoid conflicts
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        // This means: if there’s a conflict, prefer your in-memory changes
    }
}
