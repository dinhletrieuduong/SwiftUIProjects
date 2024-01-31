//
//  GradientCardAnimation.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 21/01/2024.
//

import SwiftUI

struct GradientCardAnimation: View {
    
    @State private var rotation: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            Color(hex: "1D1D1D")
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .frame(width: 260, height: 340)
                .foregroundStyle(Color(hex: "1c2e4a"))
                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
            
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .frame(width: 130, height: 500)
                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color(hex: "00FFE2"), Color(hex: "9AA2F8")]), startPoint: .top, endPoint: .bottom))
                .rotationEffect(.init(degrees: rotation))
                .mask {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(lineWidth: 7)
                        .frame(width: 256, height: 336)
                }
            
            Text("Card")
                .font(.largeTitle.bold())
                .foregroundStyle(.white)
            
        }
        .onAppear(perform: {
            withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        })
    }
}

struct DarkCard: View {
    
    @State private var rotation: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            Color(hex: "1D1D1D")
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .frame(width: 260, height: 340)
                .foregroundStyle(Color(hex: "131313"))
                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
            
            RoundedRectangle(cornerRadius: 20, style: .continuous)
            /// Change frame to show other animations
                .frame(width: 500, height: 440)
                .foregroundStyle(
                    LinearGradient(
//                        gradient: Gradient(colors: [Color(hex: "00FFE2"), Color(hex: "9AA2F8")]), 
                        gradient: Gradient(colors: [.red, .orange, .yellow, .green, .blue, .purple, .pink]),
                        startPoint: .top, endPoint: .bottom))
                .rotationEffect(.init(degrees: rotation))
                .mask {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(lineWidth: 3)
                        .frame(width: 256, height: 336)
                }
            
            Text("Card")
                .font(.largeTitle.bold())
                .foregroundStyle(.white)
            
        }
        .onAppear(perform: {
            withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        })
    }
}


#Preview {
    DarkCard()
//    GradientCardAnimation()
        .ignoresSafeArea()
}
