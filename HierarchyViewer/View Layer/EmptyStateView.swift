//
//  EmptyStateView.swift
//  HierarchyViewer
//
//  Created by Aya Fayad on 14/04/2025.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "tray")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            Text("No Items Found")
                .font(.title)
                .fontWeight(.bold)
            Text("There are currently no items available.\nPull down to refresh or try again later.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

#Preview {
    EmptyStateView()
}
