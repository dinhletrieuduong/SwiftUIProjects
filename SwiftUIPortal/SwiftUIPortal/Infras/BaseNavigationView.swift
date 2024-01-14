//
//  BaseNavigationView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 02/09/2023.
//

import SwiftUI

struct BaseNavigationStackView: View {
    
    @ObservedObject var router = Router()
    
    var body: some View {
        NavigationStack(path: $router.navPath) {
            List {
                ForEach(Route.allCases) { route in
                    if route != .empty {
                        NavigationLink(route.title, value: route)
                    }
                }
            }
            .navigationDestination(for: Route.self) { destination in
                destination.destination()
            }
        }
        .environmentObject(router)
        .ignoresSafeArea()
    }
}

#Preview {
    BaseNavigationStackView(router: Router())
}
