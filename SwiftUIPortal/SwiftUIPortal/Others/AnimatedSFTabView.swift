//
//  AnimatedSFTabView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 25/01/2024.
//

import SwiftUI

struct AnimatedSFTabView: View {
    
    /// View Properties
    @State private var currentTab: Tab = .homekit
    
    @State private var allTabs: [AnimatedTab] = Tab.allCases.compactMap({ .init(tab: $0) })
    
    var body: some View {
        VStack {
            TabView(selection: $currentTab,
                    content:  {
                NavigationStack {
                    VStack {
                        ParallaxCarouselCard()
                    }
                    .navigationTitle(Tab.homekit.title)
                }
                .setupTab(.homekit)
                
                NavigationStack {
                    VStack {
                        
                    }
                    .navigationTitle(Tab.heart.title)
                }
                .setupTab(.heart)
                
                NavigationStack {
                    VStack {
                        
                    }
                    .navigationTitle(Tab.search.title)
                }
                .setupTab(.search)
                
                NavigationStack {
                    VStack {
                        
                    }
                    .navigationTitle(Tab.profile.title)
                }
                .setupTab(.profile)
                
            })
            CustomTabBar()
        }
    }
    
    /// Custom tab bar
    @ViewBuilder
    func CustomTabBar() -> some View {
        HStack(spacing: 0) {
            ForEach($allTabs) { $animatedTab in
                let tab = animatedTab.tab
                
                VStack(spacing: 4) {
                    Image(systemName: tab.rawValue)
                        .font(.title2)
                        .symbolEffect(.bounce.down.wholeSymbol, value: animatedTab.isAnimating)
//                        .symbolEffect(.variableColor.cumulative.dimInactiveLayers, value: animatedTab.isAnimating)
                    
                    Text(tab.title)
                        .font(.title2)
                        .textScale(.secondary)
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(currentTab == tab ? .primary : .gray.opacity(0.8))
                .padding(.top, 15)
                .padding(.bottom, 10)
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.bouncy, completionCriteria: .logicallyComplete, {
                        currentTab = tab
                        animatedTab.isAnimating = true
                    }) {
                        var transaction = Transaction()
                        transaction.disablesAnimations = true
                        withTransaction(transaction) {
                            animatedTab.isAnimating = nil
                        }
                    }
                    
                }
            }
        }
    }
}

private enum Tab: String, CaseIterable {
    case homekit = "homekit"
    case heart = "heart"
    case search = "magnifyingglass"
    case profile = "person"
    
    var title: String {
        switch self {
            case .homekit:
                "Home"
            case .heart:
                "Heart"
            case .search:
                "Search"
            case .profile:
                "Profile"
        }
    }
}

private struct AnimatedTab: Identifiable {
    var id: UUID = .init()
    var tab: Tab
    var isAnimating: Bool?
}

private extension View {
    @ViewBuilder
    func setupTab(_ tab: Tab) -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity)
            .tag(tab)
            .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    AnimatedSFTabView()
}
