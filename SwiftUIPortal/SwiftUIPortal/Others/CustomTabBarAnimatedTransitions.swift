//
//  CustomTabBarAnimatedTransitions.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 24/06/2023.
//

import SwiftUI

enum Tap: String {
    case home
    case maginf
    case bell
    case rect
}
struct TapItems: Identifiable {
    var id = UUID()
    var icon: String
    var tap: Tap
}

var tapItems: [TapItems] = [
    .init(icon: "house", tap: .home),
    .init(icon: "magnifyingglass", tap: .maginf),
    .init(icon: "bell", tap: .bell),
    .init(icon: "rectangle.stack", tap: .rect),
]

struct TapBarT: View {
    @State var selectedTap: Tap = .home
    var body: some View {
        HStack {
            ForEach(tapItems) { item in
                Button {
                    withAnimation {
                        selectedTap = item.tap
                    }
                } label: {
                    VStack(spacing: 0) {
                        Image(systemName: item.icon)
                            .symbolVariant(.fill)
                            .font(.body.bold())
                            .frame(width: 30, height: 30)
                    }
                    .frame(maxWidth: .infinity)
                }
                .foregroundColor(selectedTap == item.tap ? .red : .secondary)
            }
        }
        .frame(width: 350, height: 90)
        
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(
                        LinearGradient(gradient: .init(colors: [.init(hex: "d5d5d5"), .white]), startPoint: .top, endPoint: .bottomTrailing)
                    )
                    .blur(radius: 10)
                    .offset(x: -10, y: -10)
                
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(
                        LinearGradient(gradient: .init(colors: [.init(hex: "d5d5d5"), .white]), startPoint: .top, endPoint: .bottom)
                    )
                    .padding(2)
                    .blur(radius: 1)
                
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .stroke(lineWidth: 0.1)
                    .blur(radius: 1)
            }
        )
        .overlay(content: {
            HStack {
                if selectedTap == .maginf { Spacer() }
                if selectedTap == .rect { Spacer() }
                if selectedTap == .bell {
                    Spacer()
                    Spacer()
                }
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(.red)
                    .frame(width: 65)
                    .frame(minHeight: 50, alignment: .bottom)
                if selectedTap == .home { Spacer() }
                if selectedTap == .maginf {
                    Spacer()
                    Spacer()
                }
                if selectedTap == .bell {
                    Spacer()
                }
            }
            .padding(.horizontal, 8)
        })
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: .black.opacity(0.2), radius: 20, x: 50, y: 30)
    }
}
