//
//  NetworkMonitor.swift
//  SwiftUIPortal
//
//  Created by Dylan on 16/11/2022.
//

import SwiftUI
import Network
import Foundation


final class NetworkMonitor2 {
    static let shared = NetworkMonitor2() // add in AppDelegate
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    public private(set) var isConnected: Bool = false
    
    public private(set) var connectionType: ConnectionType?
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    private init() {
        monitor = NWPathMonitor()
    }
    
    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied ? true : false
            
            self?.getConnectionType(path);
        }
    }
    
    public func stopMonitoring() {
        monitor.cancel()
    }
    
    private func getConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        }
        else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        }
        else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
        }
        else {
            connectionType = .unknown
        }
    }
    
}


class NetworkMonitor: ObservableObject {
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "monitor")
    
    var isConnected: Bool = false
    
    init() {
        networkMonitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
            
//                DispatchQueue.main.async {
//                    self.isConnected = path.status == .satisfied
//                }
            Task {
                await MainActor.run {
                    self.objectWillChange.send()
                }
            }
        }
        self.networkMonitor.start(queue: self.workerQueue)
    }
}
