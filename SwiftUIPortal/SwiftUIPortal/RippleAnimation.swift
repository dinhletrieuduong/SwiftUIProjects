//
//  RippleAnimation.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 16/01/2023.
//

import SwiftUI

struct RippleAnimation: View {
    @State var isAnimating: Bool = false
    var body: some View {
        VStack {
            let anim = Animation.easeInOut(duration: 3).repeatForever(autoreverses: false)
            let maxOpacity = 0.5
            ZStack {
                ForEach(0..<4, id: \.self) { i in
                    VStack {
                        Circle()
                            .scaleEffect(isAnimating ? 1 : 0.5)
                            .opacity(isAnimating ? 0 : maxOpacity)
                            .animation(anim.delay(Double(i)), value: isAnimating)
                    }
                }
                Circle()
                    .scaleEffect(0.5)
            }
            .foregroundColor(.blue)
            .frame(width: 200, height: 200, alignment: .center)
            .onAppear {
                isAnimating.toggle()
            }
        }
    }
}

struct RippleAnimation_Previews: PreviewProvider {
    static var previews: some View {
        RippleAnimation()
    }
}
