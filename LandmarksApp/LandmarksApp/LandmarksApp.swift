//
//  LandmarksAppApp.swift
//  LandmarksApp
//
//  Created by LAP14482 on 25/09/2021.
//

import SwiftUI

@main
struct LandmarksApp: App {
    @StateObject private var modelData = ModelData()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}
