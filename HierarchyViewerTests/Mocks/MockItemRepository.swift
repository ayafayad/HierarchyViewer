//
//  MockItemRepository.swift
//  HierarchyViewer
//
//  Created by Aya Fayad on 13/04/2025.
//

@testable import HierarchyViewer
import CoreData

class MockItemRepository: ItemRepositoryProtocol {
    
    var context: NSManagedObjectContext { coreDataStack.context }
    let coreDataStack = HierarchyViewerCoreDataStack(storageType: .inMemory)
    var deleteAllCalled = false
    var insertItemCalled = false
    
    func deleteAllSavedItems() async {
        deleteAllCalled = true
    }
    
    func insertItem(_ item: Item) async {
        insertItemCalled = true
    }
}

