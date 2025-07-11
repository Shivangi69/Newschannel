//
//  NetworkMonitor.swift
//  Newschannel
//
//  Created by apple on 10/07/25.
//


import Network
import Combine

class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    @Published var isConnected: Bool = false
    
    private init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = (path.status == .satisfied)
                print("🌐 Network Status: \(self.isConnected ? "Connected" : "Disconnected")")
            }
        }
        monitor.start(queue: queue)
    }
}
