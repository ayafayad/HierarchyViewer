//
//  HierarchyViewerCoreDataStackTests.swift
//  HierarchyViewerTests
//
//  Created by Aya Fayad on 13/04/2025.
//

import XCTest
@testable import HierarchyViewer
import CoreData

final class HierarchyViewerCoreDataStackTests: XCTestCase {
    
    var sut: HierarchyViewerCoreDataStack!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = HierarchyViewerCoreDataStack(storageType: .inMemory)
    }
    
    func testContextIsSameAsViewContext() {
        XCTAssertTrue(sut.context === sut.container.viewContext)
    }
    
    func testDeleteObjectRemovesItemFromContext() async throws {
        // Given
        let context = sut.context
        guard let entityDescription = NSEntityDescription.entity(forEntityName: CDItem.entityName,
                                                                 in: context) else {
            fatalError("Unable to find entity description for CDItem")
        }
        let newItem = CDItem(entity: entityDescription, insertInto: context)
        newItem.itemType = "page"
        newItem.title = "Main Page"
        try context.save()
        XCTAssertNotNil(newItem.objectID)
        
        // When
        await sut.deleteObject(newItem)
        
        // Then
        XCTAssertTrue(newItem.isDeleted)
    }
    
    func testModelName() {
        XCTAssertEqual(sut.modelName, "HierarchyViewer")
    }
    
    func testModelIsSameAsManagedObjectModel() {
        XCTAssertEqual(sut.model, sut.container.managedObjectModel)
    }
    
    func testFetchReturnsDataAccordingToRequest() async throws {
        // Given
        let fetchRequest = NSFetchRequest<CDItem>(entityName: CDItem.entityName)
        fetchRequest.predicate = NSPredicate(format: "itemType == %@", "page")
        let context = sut.context
        guard let entityDescription = NSEntityDescription.entity(forEntityName: CDItem.entityName,
                                                                 in: context) else {
            fatalError("Unable to find entity description for CDItem")
        }
        let pageItem = CDItem(entity: entityDescription, insertInto: context)
        pageItem.id = UUID()
        pageItem.itemType = "page"
        pageItem.title = "Main Page"
        let textItem = CDItem(entity: entityDescription, insertInto: context)
        textItem.id = UUID()
        textItem.itemType = "text"
        textItem.title = "Welcome to the main page!"
        try context.save()
        XCTAssertNotNil(pageItem.objectID)
        XCTAssertNotNil(textItem.objectID)
        
        // When
        let items: [Item] = try await sut.fetch(fetchRequest)
        
        // Then
        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items.first?.id, pageItem.id)
        XCTAssertEqual(items.first?.type, .page)
        XCTAssertEqual(items.first?.title, "Main Page")
    }
}
