//
//  ItemListView.swift
//  HierarchyViewer
//
//  Created by Aya Fayad on 11/04/2025.
//

import SwiftUI
import CoreData

struct ItemListView: View {
    
    @ObservedObject var viewModel: ItemListViewModel

    var body: some View {
        NavigationView {
            Group {
                if viewModel.shouldShowEmptyView {
                    GeometryReader { gr in
                        ScrollView {
                            VStack(alignment: .center) {
                                Spacer()
                                EmptyStateView()
                                Spacer()
                            }
                            .frame(width: gr.size.width, height: gr.size.height)
                        }
                        .scrollIndicators(.hidden)
                    }
                } else {
                    List(viewModel.items, children: \.items) { item in
                        ItemView(item: item,
                                 onTapGesture: viewModel.onTapGesture(on:),
                                 depth: item.depth)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .onAppear {
                Task {
                    await viewModel.onAppear()
                }
            }
            .refreshable {
                await viewModel.onRefresh()
            }
            .sheet(isPresented: $viewModel.shouldDisplayImageDetails, onDismiss: viewModel.onDismissItemDetails) {
                if let item = viewModel.itemToDisplay {
                    ItemDetailView(item: item)
                }
            }
        }
    }
}

#Preview {
    ItemListView(viewModel: ItemListViewModel(
        itemRepository: ItemRepository(coreDataStack: .init(storageType: .inMemory))))
}
