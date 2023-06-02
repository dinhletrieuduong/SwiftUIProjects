//
//  LiquidSwipeHome.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 09/02/2023.
//

import SwiftUI

struct LiquidSwipeHome: View {
    
    @State private var offset: CGSize = .zero
    @State private var showHome: Bool = false
    
    var body: some View {
        ZStack {
            Color(.systemPurple)
                .overlay(
                    VStack(alignment: .leading, spacing: 10, content: {
                        Text("For Gamers")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                        
                        Text("Lorem ispum, or ...")
                            .font(.caption)
                            .fontWeight(.bold)
                    })
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .offset(x: -15)
                )
                .clipShape(LiquidSwipe(offset: offset))
                .ignoresSafeArea()
                .overlay(
                    Image(systemName: "chevron.left")
                        .font(.largeTitle)
                        .frame(width: 50, height: 50)
                        .contentShape(Rectangle())
                        .gesture(DragGesture().onChanged({ value in
                            
                            withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 0.6, blendDuration: 0.6)) {
                                offset = value.translation
                            }
                        }).onEnded({ value in
                            let screen = UIScreen.main.bounds
                            withAnimation(.spring()) {
                                //                                offset = .zero
                                // Validating
                                if -offset.width > screen.width/2 {
                                    // removing view
                                    offset.width = -screen.height
                                    
                                    showHome.toggle()
                                } else {
                                    offset = .zero
                                }
                            }
                        }))
                        .offset(x: 15, y: 58)
                        .opacity(offset == .zero ? 1 : 0)
                    , alignment: .topTrailing)
            
                .padding(.trailing)
            
            if showHome {
                Text("Welcome to Home")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .onTapGesture {
                        // reseting view
                        withAnimation(.spring()) {
                            offset = .zero
                            showHome.toggle()
                        }
                    }
            }
        }
    }
}

// Custom Shape
struct LiquidSwipe: Shape {
    var offset: CGSize
    
    // Animating path
    var animatableData: CGSize.AnimatableData {
        get { return offset.animatableData }
        set {
            offset.animatableData = newValue
        }
    }
    
    func path(in rect: CGRect) -> Path {
        
        return Path { path in
            // when user moves left, increasing size both in top and bottom
            // so it will create a liquid swipe effect
            let width = rect.width + (-offset.width > 0 ? offset.width : 0)
            
            // First constructing rectangle shape
            path.move(to: .zero)
            path.addLine(to: .init(x: rect.width, y: 0))
            path.addLine(to: .init(x: rect.width, y: rect.height))
            path.addLine(to: .init(x: 0, y: rect.height))
            
            // Second constructing curve shape
            // From
            let from = 80 + (offset.width)
            path.move(to: .init(x: rect.width, y: from > 80 ? 80 : from))
            // To
            var to: CGFloat = 180 + (offset.height) + (-offset.width)
            to = to < 180 ? 180 : to
            // Middle
            let mid: CGFloat = 80 + ((to - 80) / 2)
            path.addCurve(to: .init(x: rect.width, y: to), control1: .init(x: width - 50, y: mid), control2: .init(x: width - 50, y: mid))
        }
    }
}
