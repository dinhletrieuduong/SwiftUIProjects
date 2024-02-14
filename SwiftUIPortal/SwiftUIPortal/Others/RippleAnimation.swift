//
//  RippleAnimation.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 16/01/2023.
//

import SwiftUI

struct RippleAnimationDemoView: View {
    var body: some View {
        RippleAnimation()
    }
}
struct RippleAnimation: View {
    @State var isAnimating: Bool = false
    var body: some View {
        VStack {
            let anim = Animation.easeInOut(duration: 3).repeatForever(autoreverses: false)
            let maxOpacity = 0.5
            ZStack {
                ForEach(0..<4, id: \.self) { i in
                    VStack(spacing: 0) {
                        Circle()
                            .scaleEffect(isAnimating ? 1 : 0.5, anchor: .center)
                            .opacity(isAnimating ? 0 : maxOpacity)
                            .animation(anim.delay(Double(i)), value: isAnimating)
//                            .transformEffect(.identity)
                            .clipped()
                            .scaleEffect(1)
                    }
                }
                
                Circle()
                    .scaleEffect(0.5, anchor: .center)
                
            }
            .foregroundStyle(.blue)
            .frame(width: 200, height: 200, alignment: .center)
            .onAppear {
                isAnimating.toggle()
            }
            
            
        }.ignoresSafeArea()
    }
}

#Preview {
    RippleAnimationDemoView()
}
