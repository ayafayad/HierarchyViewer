//
//  ItemListViewModelTests.swift
//  HierarchyViewerTests
//
//  Created by Aya Fayad on 13/04/2025.
//

import XCTest
@testable import HierarchyViewer
import CoreData

final class ItemListViewModelTests: XCTestCase {
    
    var sut: ItemListViewModel!
    var networkManager = MockAPIManager()
    var itemRepository = MockItemRepository()

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = ItemListViewModel(networkManager: networkManager,
                                itemRepository: itemRepository)
    }
    
    func testOnTapGestureSetsItemAndFlag() {
        // Given
        let item = Item(type: .page, title: "Main Page", image: nil, items: nil)
        
        // When
        sut.onTapGesture(on: item)
        
        // Then
        XCTAssertTrue(sut.shouldDisplayImageDetails)
        XCTAssertEqual(sut.itemToDisplay?.id, item.id)
        XCTAssertEqual(sut.itemToDisplay?.type, .page)
        XCTAssertEqual(sut.itemToDisplay?.title, "Main Page")
    }
    
    func testOnDismissItemDetailsClearsItemToDisplay() {
        // Given
        let item = Item(type: .page, title: "Main Page", image: nil, items: nil)
        sut.itemToDisplay = item
        
        // When
        sut.onDismissItemDetails()
        
        // Then
        XCTAssertNil(sut.itemToDisplay)
    }
    
    func testRefreshDataFromServerOnSuccessDeletesAndInsertsItem() async throws {
        // Given
        let item = Item(type: .page, title: "Main Page", image: nil, items: nil)
        networkManager.result = .success(item)

        // When
        await sut.onAppear()

        // Then
        XCTAssertTrue(itemRepository.deleteAllCalled)
        XCTAssertTrue(itemRepository.insertItemCalled)
    }
    
    func testRefreshDataFromServerOnFailureDoesNotCallRepository() async {
        // Given
        networkManager.result = .failure(.statusCodeError(404))

        // When
        await sut.onAppear()

        // Then
        XCTAssertFalse(itemRepository.deleteAllCalled)
        XCTAssertFalse(itemRepository.insertItemCalled)
    }
    
    func testLocalDataIsDisplayedIfNetworkCallFails() async {
        // Given
        networkManager.result = .failure(.statusCodeError(404))
        let item = Item(type: .page, title: "Main Page", image: nil, items: nil)
        let context = itemRepository.context
        await context.perform {
            let cdItem: CDItem = context.insertObject()
            cdItem.update(from: item)
            context.saveIfNeeded()
        }
        
        // When
        await sut.onAppear()
        
        // Then
        XCTAssertEqual(sut.items.count, 1)
        XCTAssertEqual(sut.items.first?.title, "Main Page")
        XCTAssertEqual(sut.items.first?.type, .page)
    }
}
