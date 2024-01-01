//
//  ContentView.swift
//  MoneyTracker
//
//  Created by Dinh Le Trieu Duong on 31/12/2023.
//

import SwiftUI
import SwiftData

// Elastic Scroll
// Split bill
// Animation Tab bar

struct ContentView: View {
    /// Visibility status
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    
    /// App lock properties
    @AppStorage("isAppLockEnabled") private var isAppLockEnabled: Bool = false
    @AppStorage("lockWhenAppGoesBackground") private var lockWhenAppGoesBackground: Bool = false
    
    /// Active tab
    @State private var activeTab: Tab = .recents
    
    var body: some View {
        LockView(lockType: .biometric, lockPin: "", isEnabled: isAppLockEnabled, lockWhenAppGoesBackground: lockWhenAppGoesBackground) {
            TabView(selection: $activeTab) {
                RecentsView()
                    .tag(Tab.recents)
                    .tabItem { Tab.recents.tabContent }
                
                SearchView()
                    .tag(Tab.search)
                    .tabItem { Tab.search.tabContent }
                
                GraphView()
                    .tag(Tab.charts)
                    .tabItem { Tab.charts.tabContent }
                
                SettingsView()
                    .tag(Tab.settings)
                    .tabItem { Tab.settings.tabContent }
            }
            .sheet(isPresented: $isFirstTime, content: {
                IntroScreen()
                    .interactiveDismissDisabled()
            })
        } forgotPin: {
            
        }

    }

}

#Preview {
    ContentView()
}
