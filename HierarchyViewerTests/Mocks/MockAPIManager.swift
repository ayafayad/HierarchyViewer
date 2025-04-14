//
//  MockAPIManager.swift
//  HierarchyViewerTests
//
//  Created by Aya Fayad on 13/04/2025.
//

import Foundation
@testable import HierarchyViewer

class MockAPIManager: APIManagerProtocol {
    
    var result: Result<Item, NetworkError>?
    
    func request<T>(_ urlString: String, type: T.Type) async -> Result<T, NetworkError> where T : Decodable {
        guard let result = result as? Result<T, NetworkError> else {
            return .failure(.invalidResponse)
        }
        return result
    }
}
