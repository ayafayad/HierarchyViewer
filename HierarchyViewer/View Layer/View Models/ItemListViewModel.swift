//
//  ItemListViewModel.swift
//  HierarchyViewer
//
//  Created by Aya Fayad on 12/04/2025.
//

import Foundation
import CoreData

class ItemListViewModel: NSObject, ObservableObject {
    
    // MARK: - Variables
    var networkManager: APIManagerProtocol
    let itemRepository: ItemRepositoryProtocol
    var itemToDisplay: Item?
    
    // MARK: - Published Variables
    @Published var items: [Item] = []
    @Published var shouldDisplayImageDetails: Bool = false
    @Published var shouldShowEmptyView: Bool = false
    
    // MARK: - Private Variables
    private let itemController: NSFetchedResultsController<CDItem>
    
    // MARK: - Init
    init(networkManager: APIManagerProtocol = APIManager(),
         itemRepository: ItemRepositoryProtocol) {
        self.networkManager = networkManager
        self.itemRepository = itemRepository
        
        itemController = NSFetchedResultsController(
            fetchRequest: CDItem.itemsWithNoParentsFetchRequest,
            managedObjectContext: itemRepository.context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        super.init()
        
        itemController.delegate = self
    }
    
    func onAppear() async {
        retrieveLocalData()
        await refreshDataFromServer()
        await refreshEmptyView()
    }
    
    func onTapGesture(on item: Item) {
        itemToDisplay = item
        shouldDisplayImageDetails = true
    }
    
    func onDismissItemDetails() {
        itemToDisplay = nil
    }
    
    func onRefresh() async {
        await refreshDataFromServer()
    }

    // MARK: - Private Helper Functions
    private func retrieveLocalData() {
        do {
            try itemController.performFetch()
            let fetchedItems = itemController.fetchedObjects?.compactMap({ Item($0) }) ?? []

            // Update UI state on the main actor.
            Task { @MainActor in
                self.items = fetchedItems
            }
        } catch {
            print("failed to fetch local data from coreData")
        }
    }
    
    private func refreshDataFromServer() async {
        let returnedModel = await networkManager.request(Constants.Network.itemsUrl, type: Item.self)
        switch returnedModel {
        case .success(let item):
            let itemsWithDepth = item.updateDepth()
            await itemRepository.deleteAllSavedItems()
            await itemRepository.insertItem(itemsWithDepth)
            await refreshEmptyView()
        case .failure(let error):
            print(error)
        }
    }
    
    @MainActor
    private func refreshEmptyView() {
        let isItemsEmpty = items.isEmpty
        guard isItemsEmpty != shouldShowEmptyView else { return }
        shouldShowEmptyView = isItemsEmpty
    }
}

extension ItemListViewModel: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        items = itemController.fetchedObjects?.compactMap({ Item($0) }) ?? []
    }
}
