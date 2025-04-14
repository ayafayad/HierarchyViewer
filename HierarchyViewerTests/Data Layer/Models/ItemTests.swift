//
//  ItemTests.swift
//  HierarchyViewerTests
//
//  Created by Aya Fayad on 15/04/2025.
//

import XCTest
@testable import HierarchyViewer

final class ItemTests: XCTestCase {

    func testResizeURLReplacesSizeParam() {
        // Given
        let url = "https://robohash.org/280?&set=set4&size=400x400"
        let sut = Item(type: .page, title: "Main Page", image: url)
        
        // Then
        XCTAssertEqual(sut.smallImgURL?.absoluteString, "https://robohash.org/280?&set=set4&size=100x100")
    }
    
    func testResizeUrlAppendsSizeIfMissing() {
        // Given
        let url = "https://robohash.org/280?&set=set4"
        let sut = Item(type: .page, title: "Main Page", image: url)
        
        // Then
        XCTAssertEqual(sut.smallImgURL?.absoluteString, "https://robohash.org/280?&set=set4&size=100x100")
    }
    
    func testUpdateDepth() {
        // Given
        let sut = Item(type: .page, title: "Main Page", image: nil, items: [
            .init(type: .section, title: "Introduction", image: nil, items: [
                .init(type: .text, title: "Welcome to the main page!", image: nil)
            ])
        ])
        
        // When
        let result = sut.updateDepth()
        
        // Then
        XCTAssertEqual(result.depth, 0)
        XCTAssertEqual(result.items?.first?.depth, 1)
        XCTAssertEqual(result.items?.first?.items?.first?.depth, 2)
    }

}
