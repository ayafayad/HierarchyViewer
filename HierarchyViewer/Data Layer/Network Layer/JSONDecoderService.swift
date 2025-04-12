//
//  JSONDecoderService.swift
//  HierarchyViewer
//
//  Created by Aya Fayad on 11/04/2025.
//

import Foundation

class JSONDecoderService {
    
    let decoder = JSONDecoder()
    
    func decode<T: Decodable>(from jsonData: Data) throws -> T {
        return try decoder.decode(T.self, from: jsonData)
    }
}
