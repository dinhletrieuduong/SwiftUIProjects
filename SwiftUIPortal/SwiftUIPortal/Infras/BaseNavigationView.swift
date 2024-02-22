//
//  BaseNavigationView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 02/09/2023.
//

import SwiftUI

struct BaseNavigationStackView: View {
    
    @ObservedObject var router = Router()
    
    let columns: [GridItem] = [
        .init(),
        .init(),
    ]
    
    var body: some View {
        NavigationStack(path: $router.navPath) {
            List {
                //                LazyVGrid(columns: columns, spacing: 0, content: {
                ForEach(Route.allCases, id: \.title) { route in
                    if route != .empty {
                        NavigationLink(value: route) {
                            Text(route.title)
                        }
                        //                            NavigationLink(route.title, value: route)
                        
                        
                        .padding(.vertical)
                    }
                    
                }
                //                })
            }
            .listStyle(.insetGrouped)
            .navigationDestination(for: Route.self) { destination in
                destination.destination()
            }
            .navigationTitle("Portfolios")
        }
        .environmentObject(router)
        .ignoresSafeArea()
    }
}

#Preview {
    BaseNavigationStackView(router: Router())
}
