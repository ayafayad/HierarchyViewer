//
//  HierarchyViewerApp.swift
//  HierarchyViewer
//
//  Created by Aya Fayad on 11/04/2025.
//

import SwiftUI

@main
struct HierarchyViewerApp: App {

    var body: some Scene {
        WindowGroup {
            ItemListView(viewModel: ItemListViewModel(itemRepository: ItemRepository()))
        }
    }
}
