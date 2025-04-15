//
//  HierarchyViewerApp.swift
//  HierarchyViewer
//
//  Created by Aya Fayad on 11/04/2025.
//

import SwiftUI

@main
struct HierarchyViewerApp: App {
    
    @StateObject private var coordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            coordinator.rootView
        }
    }
}
