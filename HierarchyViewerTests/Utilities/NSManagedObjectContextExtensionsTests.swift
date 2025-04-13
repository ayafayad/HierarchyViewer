//
//  NSManagedObjectContextExtensionsTests.swift
//  HierarchyViewerTests
//
//  Created by Aya Fayad on 13/04/2025.
//

import XCTest
@testable import HierarchyViewer
import CoreData

final class NSManagedObjectContextExtensionsTests: XCTestCase {
    
    var context: NSManagedObjectContext!

    override func setUpWithError() throws {
        try super.setUpWithError()
        let container = NSPersistentContainer(name: "HierarchyViewer")
        container.enableAutomaticMigrations()
        container.setStorageTypeToInMemory()
        container.loadPersistentStores { _, error in
            XCTAssertNil(error)
        }
        context = container.viewContext
    }
    
    func testInsertObjectCreatesNewInstance() {
        // When
        let item: CDItem = context.insertObject()
        
        // Then
        XCTAssertEqual(item.entity.name, CDItem.entityName)
    }
    
    func testSaveIfNeededWithChanges() {
        // Given
        let item: CDItem = context.insertObject()
        item.id = UUID()
        item.itemType = "page"
        item.title = "Main Page"
        
        // Then
        XCTAssertTrue(context.hasChanges)

        // When
        context.saveIfNeeded()
        
        // Then
        XCTAssertFalse(context.hasChanges)
    }
}
