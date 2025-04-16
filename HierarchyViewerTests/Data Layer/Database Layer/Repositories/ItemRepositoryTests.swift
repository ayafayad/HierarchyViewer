//
//  ItemRepositoryTests.swift
//  HierarchyViewerTests
//
//  Created by Aya Fayad on 13/04/2025.
//

import XCTest
@testable import HierarchyViewer
import CoreData

final class ItemRepositoryTests: XCTestCase {
    
    var coreDataStack: HierarchyViewerCoreDataStack!
    var sut: ItemRepository!

    override func setUpWithError() throws {
        try super.setUpWithError()
        coreDataStack = HierarchyViewerCoreDataStack(storageType: .inMemory)
        sut = ItemRepository(coreDataStack: coreDataStack)
    }
    
    func testInsertItemInsertsItemToDatabase() async throws {
        // Given
        let item = Item(type: .page, title: "Main Page", image: nil, items: [])
        
        // When
        await sut.insertItem(item)
        
        // Then
        let fetchRequest = NSFetchRequest<CDItem>(entityName: CDItem.entityName)
        let count = try coreDataStack.context.count(for: fetchRequest)
        XCTAssertEqual(count, 1, "Expected one CDItem after insertion.")
                
        let results = try coreDataStack.context.fetch(fetchRequest)
        let returnedItem = try XCTUnwrap(results.first)
        XCTAssertEqual(returnedItem.title, "Main Page")
        XCTAssertEqual(returnedItem.itemType, "page")
        XCTAssertEqual(returnedItem.id, item.id)
    }
    
    /// Unit test cannot be written for this function because NSBatchDeleteRequest is only supported
    /// with a SQLite persistent store. In our test environment we use an in-memory store for speed
    /// and isolation.
    func testDeleteAllSavedItems() {}

}
