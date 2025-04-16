//
//  AppCoordinator.swift
//  HierarchyViewer
//
//  Created by Aya Fayad on 15/04/2025.
//

import SwiftUI

/// The AppCoordinator is responsible for creating and coordinating the main flows of the app.
final class AppCoordinator: ObservableObject {
    
    // MARK: - Variables
    let itemRepository: ItemRepository
    let itemListViewModel: ItemListViewModel
    
    // MARK: - Init
    init() {
        self.itemRepository = ItemRepository()
        self.itemListViewModel = ItemListViewModel(itemRepository: itemRepository)
    }
    
    // MARK: - Root View
    
    /// The root view for the app, provided by the coordinator.
    @ViewBuilder
    var rootView: some View {
        // Here you can also embed additional navigation logic if needed.
        ItemListView(viewModel: itemListViewModel)
    }
}
