//
//  HierarchyViewerApp.swift
//  HierarchyViewer
//
//  Created by Aya Fayad on 11/04/2025.
//

import SwiftUI

@main
struct HierarchyViewerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
