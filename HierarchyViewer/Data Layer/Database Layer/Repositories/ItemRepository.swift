//
//  ItemRepository.swift
//  HierarchyViewer
//
//  Created by Aya Fayad on 12/04/2025.
//

import Foundation
import CoreData

protocol ItemRepositoryProtocol: AnyObject {
    var context: NSManagedObjectContext { get }
    func deleteAllSavedItems() async
    func insertItem(_ item: Item) async
}

class ItemRepository {
    
    var coreDataStack: HierarchyViewerCoreDataStack
    
    init(coreDataStack: HierarchyViewerCoreDataStack = .shared) {
        self.coreDataStack = coreDataStack
    }
}

extension ItemRepository: ItemRepositoryProtocol {
    
    var context: NSManagedObjectContext {
        coreDataStack.context
    }
    
    func deleteAllSavedItems() async {
        guard let request = CDItem.fetchRequest as? NSFetchRequest<NSFetchRequestResult> else { return }
        await context.perform {
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            batchDeleteRequest.resultType = .resultTypeObjectIDs
            do {
                if let result = try self.context.execute(batchDeleteRequest) as? NSBatchDeleteResult,
                   let objectIDArray = result.result as? [NSManagedObjectID] {
                    let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: objectIDArray]
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes,
                                                        into: [self.context])
                }
            } catch {
                print("Failed to delete all saved items!")
            }
        }
    }
    
    func insertItem(_ item: Item) async {
        await context.perform {
            let object: CDItem = self.context.insertObject()
            object.update(from: item)
            self.context.saveIfNeeded()
        }
    }
}
