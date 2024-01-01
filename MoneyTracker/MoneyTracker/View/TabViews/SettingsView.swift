//
//  SettingsView.swift
//  MoneyTracker
//
//  Created by Dinh Le Trieu Duong on 31/12/2023.
//

import SwiftUI

struct SettingsView: View {
    /// User properties
    @AppStorage("username") private var username: String = ""
    
    /// App lock properties
    @AppStorage("isAppLockEnabled") private var isAppLockEnabled: Bool = false
    @AppStorage("lockWhenAppGoesBackground") private var lockWhenAppGoesBackground: Bool = false
    var body: some View {
        NavigationStack {
            List {
                Section("Username") {
                    TextField("Dylan", text: $username)
                }
                
                Section("App Lock") {
                    Toggle("Enable App Lock", isOn: $isAppLockEnabled)
                    
                    if isAppLockEnabled {
                        Toggle("Lock When App Goes Background", isOn: $lockWhenAppGoesBackground)
                    }
                    
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
