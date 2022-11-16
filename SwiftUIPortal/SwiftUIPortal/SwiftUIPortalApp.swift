//
//  SwiftUIPortalApp.swift
//  SwiftUIPortal
//
//  Created by Dylan on 14/11/2022.
//

import SwiftUI

@main
struct SwiftUIPortalApp: App {
    
    @StateObject private var networkMonitor = NetworkMonitor()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(networkMonitor)
        }
    }
}
