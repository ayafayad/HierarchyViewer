//
//  EmptyStateView.swift
//  HierarchyViewer
//
//  Created by Aya Fayad on 14/04/2025.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        ContentUnavailableView(
            "No Items Found",
            systemImage: "tray",
            description: Text("There are currently no items available.\nPull down to refresh or try again later."))
    }
}

#Preview {
    EmptyStateView()
}
