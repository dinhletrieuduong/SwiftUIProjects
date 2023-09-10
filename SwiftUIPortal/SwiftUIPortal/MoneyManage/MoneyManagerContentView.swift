//
//  ContentView.swift
//  money-manage
//
//  Created by Dylan on 02/11/2022.
//

import SwiftUI

struct MoneyManagerContentView: View {
    var body: some View {
        TabView {
            CardsScreen()
                .tabItem { Label("Home", systemImage: "house") }
            VStack {}
            .tabItem { Label("Statistic", systemImage: "table") }
            VStack {}
            .tabItem { Label("Wallet", systemImage: "dollarsign.square") }
            VStack {}
            .tabItem { Label("Profile", systemImage: "person") }
        }
        
    }
}

struct MoneyManagerContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
