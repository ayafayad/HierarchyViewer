//
//  CoreDataStack.swift
//  HierarchyViewer
//
//  Created by Aya Fayad on 11/04/2025.
//

import Foundation
import CoreData

protocol CoreDataStack: AnyObject {
    
    static var shared: Self { get }
    
    var modelName: String { get }
    var container: NSPersistentContainer { get }
    var model: NSManagedObjectModel { get }
    var context: NSManagedObjectContext { get }
    
    func deleteObject<T: NSManagedObject>(_ object: T) async
    func saveContext() async
    func fetch<Output, CDOutput>(_ request: NSFetchRequest<CDOutput>) async throws -> [Output] where CDOutput: Managed, CDOutput: NSManagedObject, Output: Mappable
}


extension CoreDataStack {
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    var model: NSManagedObjectModel {
        return container.managedObjectModel
    }
    
    func deleteObject<T: NSManagedObject>(_ object: T) async {
        await context.perform {
            self.context.delete(object)
        }
    }
    
    func saveContext() async {
        await context.perform {
            self.context.saveIfNeeded()
        }
    }
    
    func fetch<Output, CDOutput>(_ request: NSFetchRequest<CDOutput>) async throws -> [Output] where CDOutput: Managed, CDOutput: NSManagedObject, Output: Mappable {
        try await context.perform {
            let fetchedData = try self.context.fetch(request)
            return fetchedData.compactMap({ Output($0) })
        }
    }
}

/// This is used when unit testing.
enum StorageType {
    case persistent, inMemory
}
