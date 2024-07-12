//
//  File.swift
//  
//
//  Created by Bechir Kefi on 12/7/2024.
//

import Foundation
import CoreData

public class CoreDataStack {

    public static let shared = CoreDataStack()
    
    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        // Find the URL for the model in the package resources
        let bundle = Bundle(for: CoreDataStack.self)
        guard let modelURL = bundle.url(forResource: "ContactsManagerModel", withExtension: "momd", subdirectory: "ContactsManager_Sources/ContactsManager/Model") else {
            fatalError("Failed to locate Data Model in bundle.")
        }
        
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to load Data Model.")
        }
        
        let container = NSPersistentContainer(name: "ContactsManagerModel", managedObjectModel: model)
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    public var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    public func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
