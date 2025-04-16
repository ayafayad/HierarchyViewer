//
//  MockNetworkMonitor.swift
//  HierarchyViewerTests
//
//  Created by Aya Fayad on 15/04/2025.
//

import Foundation
@testable import HierarchyViewer

class MockNetworkMonitor: NetworkMonitor {
    
    var isNetworkReachable: Bool
    
    init(isReachable: Bool) {
        self.isNetworkReachable = isReachable
    }
    
    func isReachable() -> Bool {
        return isNetworkReachable
    }
}
