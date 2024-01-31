//
//  CustomBottomTabBar.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 21/01/2024.
//

import SwiftUI

struct CustomBottomTabBar: View {
    
    @State private var currentTab: Tab = .Notifications
    
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
                .tag(Tab.Home)
            
            Text("Search View")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.black)
                .foregroundStyle(.white)
                .tag(Tab.Search)
            
            Text("Notification View")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.black)
                .foregroundStyle(.white)
                .tag(Tab.Notifications)
            
            Text("Profile View")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.black)
                .foregroundStyle(.white)
                .tag(Tab.Profile)
            
            Text("Cart View")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.black)
                .foregroundStyle(.white)
                .tag(Tab.Cart)
            
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
                    Image(systemName: currentTab == tab ? tab.fill : tab.rawValue)
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
                                    
                                    Text(tab.tabName)
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

private enum Tab: String, CaseIterable {
    case Home = "house"
    case Search = "magnifyingglass.circle"
    case Notifications = "bell"
    case Profile = "person"
    case Cart = "cart"
    
    var tabName: String {
        switch self {
            case .Home:
                return "Home"
            case .Search:
                return "Search"
            case .Notifications:
                return "Notification"
            case .Profile:
                return "Profile"
            case .Cart:
                return "Cart"
        }
    }
    
    var fill: String {
        return self.rawValue + ".fill"
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
    CustomBottomTabBar()
}
