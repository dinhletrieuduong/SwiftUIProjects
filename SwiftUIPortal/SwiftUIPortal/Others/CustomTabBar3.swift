//
//  CustomTabBar3.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 11/02/2024.
//

import SwiftUI

struct CustomTabBar3DemoView: View {
    var body: some View {
        CustomTabBar3()
    }
}

struct CustomTabBar3: View {
    
    @State private var activeTab: Tab2 = .home
    @State private var tabShapePosition: CGPoint = .zero
    
    @Namespace private var animation
    
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $activeTab,
                    content:  {
                Text("Home")
                    .tag(Tab2.home)
//                    .toolbar(.hidden, for: .tabBar)
                
                Text("Services")
                    .tag(Tab2.services)
                
                Text("Partners")
                    .tag(Tab2.partners)
                
                Text("Activity")
                    .tag(Tab2.activity)
            })
            
            CustomTabBar()
        }
    }
    
    @ViewBuilder
    private func CustomTabBar(_ tint: Color = .blue, inactiveTint: Color = .blue.opacity(0.8)) -> some View {
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(Tab2.allCases, id: \.rawValue) { tab in
                TabItem(tint: tint, inactiveTint: inactiveTint, tab: tab, animation: animation, activeTab: $activeTab, position: $tabShapePosition)
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background {
            TabShape(midPoint: tabShapePosition.x)
                .fill(.white)
                .ignoresSafeArea()
                .shadow(color: tint.opacity(0.2), radius: 5, x: 0, y: -5)
                .blur(radius: 2)
                .padding(.top, 25)
        }
        .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7), value: activeTab)
    }
    
    
}

struct TabItem: View {
    var tint: Color
    var inactiveTint: Color
    var tab: Tab2
    var animation: Namespace.ID
    @Binding var activeTab: Tab2
    @Binding var position: CGPoint
    
    @State private var tabPosition: CGPoint = .zero
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: tab.systemImage)
                .font(.title2)
                .foregroundStyle(activeTab == tab ? .white : inactiveTint)
                .frame(width: activeTab == tab ? 58 : 35, height: activeTab == tab ? 58 : 35)
                .background {
                    if activeTab == tab {
                        Circle()
                            .fill(tint.gradient)
                            .matchedGeometryEffect(id: "ACTIVE_TAB", in: animation)
                        
                    }
                }
            Text(tab.rawValue)
                .font(.caption)
                .foregroundStyle(activeTab == tab ? tint : .gray)
            
        }
        .frame(maxWidth: .infinity)
        .contentShape(.rect)
        .viewPosition(completion: { rect in
            tabPosition.x = rect.midX
            
            if activeTab == tab {
                position.x = rect.midX
            }
        })
        .onTapGesture {
            activeTab = tab
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                position.x = tabPosition.x
            }
        }
    }
}

#Preview {
    CustomTabBar3DemoView()
        .preferredColorScheme(.light)
}

enum Tab2: String, CaseIterable {
    case home = "Home"
    case services = "Services"
    case partners = "Partners"
    case activity = "Activity"
    
    var systemImage: String {
        switch self {
            case .home:
                "house"
            case .services:
                "envelope.open.badge.clock"
            case .partners:
                "hand.raised"
            case .activity:
                "bell"
        }
    }
    
    var index: Int {
        return Tab2.allCases.firstIndex(of: self) ?? 0
    }
}

struct TabShape: Shape {
    var midPoint: CGFloat
    
    var animatableData: CGFloat {
        get {
            midPoint
        }
        
        set {
            midPoint = newValue
        }
    }
    
    func path(in rect: CGRect) -> Path {
        return Path({ path in
            /// 1. Drawing the Rectangle shape
            path.addPath(Rectangle().path(in: rect))
            
            /// 2. Drawing upward curve shape
            path.move(to: .init(x: midPoint - 60, y: 0))
            
            let to = CGPoint(x: midPoint, y: -25)
            let control1 = CGPoint(x: midPoint - 25, y: 0)
            let control2 = CGPoint(x: midPoint - 25, y: -25)
            
            path.addCurve(to: to, control1: control1, control2: control2)
            
            let to1 = CGPoint(x: midPoint + 60, y: 0)
            let control3 = CGPoint(x: midPoint + 25, y: -25)
            let control4 = CGPoint(x: midPoint + 25, y: 0)
            
            path.addCurve(to: to1, control1: control3, control2: control4)
        })
        
    }
}

/// Custom View Extension
/// Which will return view position
struct PositionKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

extension View {
    @ViewBuilder
    func viewPosition(completion: @escaping (CGRect) -> Void) -> some View {
        self
            .overlay {
                GeometryReader {
                    let rect = $0.frame(in: .global)
                    
                    Color.clear
                        .preference(key: PositionKey.self, value: rect)
                        .onPreferenceChange(PositionKey.self, perform: completion)
                    
                }
            }
    }
}
