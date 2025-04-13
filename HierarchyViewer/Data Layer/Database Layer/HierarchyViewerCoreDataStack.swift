//
//  CoreDataManager.swift
//  HierarchyViewer
//
//  Created by Aya Fayad on 11/04/2025.
//

import CoreData

final class HierarchyViewerCoreDataStack: CoreDataStack {
    
    // MARK: - CoreDataStack
    static var shared: HierarchyViewerCoreDataStack = HierarchyViewerCoreDataStack()
    var modelName: String
    var container: NSPersistentContainer
    
    // MARK: - Constants
    private struct Constants {
        static let modelName = "HierarchyViewer"
        static let retryCount = 5
    }
    
    // MARK: - Init
    init(storageType: StorageType = .persistent) {
        self.modelName = Constants.modelName
        self.container = NSPersistentContainer(name: modelName)
        self.container.enableAutomaticMigrations()
        // Used for unit testing purposes
        if storageType == .inMemory {
            self.container.setStorageTypeToInMemory()
        }
        Self.loadStores(for: container, retryCount: 0)
    }
    
    private static func loadStores(for container: NSPersistentContainer, retryCount: Int) {
        container.loadPersistentStores { (description, error) in
            if let error = error {
                guard retryCount < Constants.retryCount else {
                    let error = "Could not load the persistent stores: \(error)"
                    assertionFailure(error)
                    // TODO: - Use an Application monitoring software and log this error
                    print(error)
                    return
                }
                Self.loadStores(for: container, retryCount: retryCount + 1)
                return
            }
        }
    }
}
