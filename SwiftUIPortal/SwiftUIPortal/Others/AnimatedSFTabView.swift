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
                        Image(systemName: "visionpro")
                            .font(.system(size: 300, weight: .ultraLight))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.gray, .black, .gray], startPoint: .top, endPoint: .bottom),
                                EllipticalGradient(
                                    colors: [.purple, .black], center: .center, startRadiusFraction: 0.0, endRadiusFraction: 0.55)
                            )
                            .shadow(color: .white, radius: 1)
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

enum Tab: String, CaseIterable {
    case homekit = "homekit"
    case heart = "heart"
    case search = "magnifyingglass"
    case profile = "person"
//    case notifications = "bell"
    case cart = "cart"
    
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
//            case .notifications:
//                "Notification"
            case .cart:
                "Cart"
        }
    }
    
    var fill: String {
        return self.rawValue + ".fill"
    }
}

//private enum Tab: String, CaseIterable {
//    case Home = "house"
//    case Search = "magnifyingglass.circle"
//    case Notifications = "bell"
//    case Profile = "person"
//    case Cart = "cart"
//
//    var tabName: String {
//        switch self {
//            case .Home:
//                return "Home"
//            case .Search:
//                return "Search"
//            case .Notifications:
//                return "Notification"
//            case .Profile:
//                return "Profile"
//            case .Cart:
//                return "Cart"
//        }
//    }
//
//    var fill: String {
//        return self.rawValue + ".fill"
//    }
//}

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


struct CustomBottomTabBar: View {
    
    @State private var currentTab: Tab = .homekit
    
    /// Hide Nav bar
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    /// Matched Geometry effect
    @Namespace var animation
    
    var body: some View {
        TabView(selection: $currentTab, content:  {
            Text("Home View")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.black)
                .foregroundStyle(.white)
                .tag(Tab.homekit)
            
            Text("Search View")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.black)
                .foregroundStyle(.white)
                .tag(Tab.search)
            
            Text("Notification View")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.black)
                .foregroundStyle(.white)
                .tag(Tab.heart)
            
            Text("Profile View")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.black)
                .foregroundStyle(.white)
                .tag(Tab.profile)
            
            //            Text("Cart View")
            //                .frame(maxWidth: .infinity, maxHeight: .infinity)
            //                .background(.black)
            //                .foregroundStyle(.white)
            //                .tag(Tab.Cart)
            
        })
        .overlay(alignment: .bottom) {
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    TabButton(tab: tab)
                    
                }
                .padding(.vertical)
                .padding(.bottom, getSafeArea().bottom == 0 ? 5 : (getSafeArea().bottom - 15))
                .background(.white)
            }
            
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
    
    @ViewBuilder
    private func TabButton(tab: Tab) -> some View {
        GeometryReader(content: { geometry in
            Button(action: {
                withAnimation(.spring()) {
                    currentTab = tab
                }
            }, label: {
                VStack {
                    Image(systemName: tab.rawValue) // currentTab == tab ? tab.fill : tab.rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(currentTab == tab ? .primary : .secondary)
                        .padding(currentTab == tab ? 15 : 0)
                        .background(
                            ZStack {
                                if currentTab == tab {
                                    MaterialEffect(style: .light)
                                        .clipShape(.circle)
                                        .matchedGeometryEffect(id: "TAB", in: animation)
                                    
                                    Text(tab.title)
                                        .foregroundStyle(.primary)
                                        .font(.footnote)
                                        .padding(.top, 50)
                                    
                                }
                            }
                        )
                        .contentShape(.rect)
                        .offset(y: currentTab == tab ? -35 : 0)
                }
            })
        })
        .frame(height: 25)
    }
}

struct MaterialEffect: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}

extension View {
    func getSafeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return .zero }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else { return .zero }
        
        return safeArea
    }
}


#Preview {
    AnimatedSFTabView()
//    CustomBottomTabBar()
}
