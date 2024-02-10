//
//  CustomTabBar2.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 08/02/2024.
//

import SwiftUI

struct CustomTabBar2Demo: View {
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    @State private var currentTab: Tab = .homekit
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentTab) {
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
            }
            
            CustomTabBar2(currentTab: $currentTab)
        }
    }
}

struct CustomTabBar2: View {
    @Binding var currentTab: Tab
    @State private var yOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            currentTab = tab
                            yOffset = -60
                        }
                        withAnimation(.easeInOut(duration: 0.1).delay(0.075)) {
                            yOffset = 0
                        }
                    } label: {
                        Image(systemName: tab.rawValue)
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(currentTab == tab ? Color.purple : .gray)
                            .scaleEffect(currentTab == tab && yOffset != 0 ? 1.5 : 1)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .background(alignment: .leading) {
                Circle()
                    .fill(.yellow)
                    .frame(width: 25, height: 25)
                    .offset(x: 10, y: yOffset)
                    .offset(x: indicatorOffset(width: proxy.size.width))
            }
        }
        .frame(height: 30)
        .padding(.bottom, 10)
        .padding([.horizontal, .top])
    }
    
    private func indicatorOffset(width: CGFloat) -> CGFloat {
        let index = CGFloat(getIndex())
        if index == 0 { return 0}
        
        let buttonWidth = width / CGFloat(Tab.allCases.count)
        return index * buttonWidth
    }
    
    private func getIndex() -> Int {
        switch currentTab {
            case .homekit:
                0
            case .heart:
                1
            case .search:
                2
            case .profile:
                3
            case .cart:
                4
            default:
                0
        }
    }
}

#Preview {
    CustomTabBar2Demo()
}
