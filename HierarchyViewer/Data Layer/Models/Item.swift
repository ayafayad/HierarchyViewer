//
//  ItemModel.swift
//  HierarchyViewer
//
//  Created by Aya Fayad on 11/04/2025.
//

import Foundation

struct Item: Codable, Identifiable {
    
    /// A unique identifier for the item.
    /// This ensures each instance is distinct, supporting reliable lookups and data integrity.
    /// TODO: - Should be linked to backend ID
    var id = UUID()
    let type: ItemType
    let title: String?
    let image: String?
    let items: [Item]?
    var sortIndex: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case type, title, items
        case image = "src"
    }
}
