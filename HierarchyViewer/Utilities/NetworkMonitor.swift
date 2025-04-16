//
//  NetworkMonitor.swift
//  HierarchyViewer
//
//  Created by Aya Fayad on 15/04/2025.
//

import SwiftUI
import Network

protocol NetworkMonitor {
    func isReachable() -> Bool
}

class PathNetworkMonitor: NetworkMonitor {
    
    private let monitor: NWPathMonitor
    private let queue: DispatchQueue
    private var isConnected = false

    init() {
        monitor = NWPathMonitor()
        queue = DispatchQueue(label: "NetworkMonitor")
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        monitor.start(queue: self.queue)
    }
    
    func isReachable() -> Bool {
        return queue.sync {
            isConnected
        }
    }
}
