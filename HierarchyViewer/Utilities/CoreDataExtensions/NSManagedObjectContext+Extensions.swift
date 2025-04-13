//
//  NSManagedObjectContext+Extensions.swift
//  HierarchyViewer
//
//  Created by Aya Fayad on 11/04/2025.
//

import CoreData

protocol Managed: NSFetchRequestResult {
    static var entityName: String { get }
}

extension Managed where Self: NSManagedObject {
        
    static var entityName: String { return String(describing: self) }
    
    static var fetchRequest: NSFetchRequest<Self> {
        return NSFetchRequest<Self>(entityName: entityName)
    }
}

extension NSManagedObjectContext {
    
    func insertObject<A: NSManagedObject>() -> A where A: Managed {
        guard let object = NSEntityDescription.insertNewObject(forEntityName: A.entityName, into: self) as? A else {
            fatalError("Wrong object type \(A.self); entityName: \(A.entityName)")
        }
        return object
    }
    
    func saveIfNeeded() {
        guard self.hasChanges else { return }
        do {
            try save()
        } catch {
            print("An Error \(error) occured while trying to save context \(self)")
        }
    }
}
