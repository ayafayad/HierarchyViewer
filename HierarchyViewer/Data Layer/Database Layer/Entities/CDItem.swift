//
//  CDItem.swift
//  HierarchyViewer
//
//  Created by Aya Fayad on 12/04/2025.
//

import Foundation
import CoreData

protocol Mappable {
    init?<T: NSManagedObject>(_ cdModel: T) where T: Managed
}

@objc(CDItem)
public class CDItem: NSManagedObject, Managed {
   
    @NSManaged public var id: UUID
    @NSManaged public var itemType: String
    @NSManaged public var title: String?
    @NSManaged public var image: String?
    @NSManaged public var items: NSOrderedSet?
    @NSManaged public var parent: CDItem?
    @NSManaged public var depth: Int
    
    public static var itemsWithNoParentsFetchRequest: NSFetchRequest<CDItem> {
        let request: NSFetchRequest<CDItem> = CDItem.fetchRequest
        request.predicate = NSPredicate(format: "parent == nil")
        request.sortDescriptors = []
        return request
    }
}

extension CDItem {
    
    func update(from item: Item) {
        self.id = item.id
        self.itemType = item.type.rawValue
        self.title = item.title
        self.image = item.image
        if let items = item.items,
           let context = self.managedObjectContext {
            // Map the incoming array of child models into an array of CDItem objects.
            let childEntities: [CDItem] = items.map { model in
                let entity: CDItem = context.insertObject()
                entity.update(from: model)
                entity.parent = self
                return entity
            }
            // Convert the array into an NSOrderedSet to preserve order.
            self.items = NSOrderedSet(array: childEntities)
        } else {
            self.items = []
        }
        self.depth = item.depth
    }
}

extension Item: Mappable {
    
    init?<T>(_ cdModel: T) where T : NSManagedObject, T : Managed {
        guard let cdItem = cdModel as? CDItem,
              let itemType = ItemType(rawValue: cdItem.itemType) else { return nil }
        self.id = cdItem.id
        self.type = itemType
        self.title = cdItem.title
        self.image = cdItem.image
        self.items = (cdItem.items?.array as? [CDItem])?.compactMap({ Item($0) })
        if self.items?.isEmpty == true {
            self.items = nil
        }
        self.depth = cdItem.depth
    }
}
