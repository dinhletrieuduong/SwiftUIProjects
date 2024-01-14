//
//  MoneyTrackerApp.swift
//  MoneyTracker
//
//  Created by Dinh Le Trieu Duong on 31/12/2023.
//

import SwiftUI
import SwiftData
import WidgetKit

@main
struct MoneyTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    WidgetCenter.shared.reloadAllTimelines()
                    /// Can also make use of scene phase and reload the widget whenever the app goes to background
                }
        }
        .modelContainer(for: [Transaction.self])
    }
}
