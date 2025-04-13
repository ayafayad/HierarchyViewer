//
//  NSPersistentContainer+Extensions.swift
//  HierarchyViewer
//
//  Created by Aya Fayad on 11/04/2025.
//

import CoreData

extension NSPersistentContainer {
    
    func setStorageTypeToInMemory() {
        guard let description = persistentStoreDescriptions.first else {
            assertionFailure("description missing"); return
        }
        description.type = NSInMemoryStoreType
    }
    
    func enableAutomaticMigrations() {
        guard let description = persistentStoreDescriptions.first else {
            assertionFailure("description missing"); return
        }
        description.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)
        description.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
    }
}
