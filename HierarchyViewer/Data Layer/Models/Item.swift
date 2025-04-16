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
    var items: [Item]?
    var depth: Int = 0
    
    // MARK: - Computed Variables
    var largeImageURL: URL? {
        guard let image else { return nil }
        return URL(string: image)
    }
    var smallImgURL: URL? {
        resizeURL(to: Constants.ImageProperties.reducedImgSize)
    }
    
    enum CodingKeys: String, CodingKey {
        case type, title, items
        case image = "src"
    }
    
    func updateDepth(depth: Int = 0) -> Item {
        var updatedItem = self
        updatedItem.depth = depth
        if let children = self.items, !children.isEmpty {
            updatedItem.items = children.map { $0.updateDepth(depth: depth + 1) }
        }
        return updatedItem
    }
    
    private func resizeURL(to size: String) -> URL? {
        guard let image, let url = URL(string: image) else { return nil }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        var queryItems = components?.queryItems ?? []
        if let index = queryItems.firstIndex(where: { $0.name == "size" }) {
            queryItems[index].value = size
        } else {
            queryItems.append(URLQueryItem(name: "size", value: size))
        }
        components?.queryItems = queryItems
        return components?.url ?? url
    }
}
