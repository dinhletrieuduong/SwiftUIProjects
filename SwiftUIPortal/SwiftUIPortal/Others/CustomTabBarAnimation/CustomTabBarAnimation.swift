//
//  CustomTabBarAnimation.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 08/02/2024.
//

import SwiftUI

struct CustomTabBarAnimation: View {
    
    @State private var tabSelection: Int = 0
    
    var body: some View {
        VStack {
            BookInfoView()
            TabSelectionView(tabSelection: $tabSelection)
            
            TabView(selection: $tabSelection,
                    content:  {
                
                DiscussinListView()
                    .tag(0)
                
                Text("Tab 2")
                    .font(.largeTitle)
                    .foregroundStyle(.black)
                    .tag(1)
                
                Text("Tab 3")
                    .font(.largeTitle)
                    .foregroundStyle(.black)
                    .tag(2)
                
            })
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

#Preview {
    CustomTabBarAnimation()
}
