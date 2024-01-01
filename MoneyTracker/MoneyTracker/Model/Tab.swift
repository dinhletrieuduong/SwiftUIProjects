//
//  Tab.swift
//  MoneyTracker
//
//  Created by Dinh Le Trieu Duong on 31/12/2023.
//

import SwiftUI

enum Tab: String {
    case recents = "Recents"
    case search = "Filter"
    case charts = "Charts"
    case settings = "Settings"
    
    @ViewBuilder
    var tabContent: some View {
        switch self {
            case .recents:
                Image(systemName: "calendar")
                Text(self.rawValue)
            case .search:
                Image(systemName: "magnifyingglass")
                Text(self.rawValue)
            case .charts:
                Image(systemName: "chart.bar.xaxis")
                Text(self.rawValue)
            case .settings:
                Image(systemName: "gearshape")
                Text(self.rawValue)
        }
    }
}
