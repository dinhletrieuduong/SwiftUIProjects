//
//  AWBreathAnimation.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 16/01/2023.
//

import SwiftUI

struct AWBreathAnimation: View {
    @State var isAnimating: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    BreathView(multiplier: isAnimating ? 1 : 0)
                }
                .scaleEffect(isAnimating ? 1 : 0.5)
                .rotationEffect(.degrees(isAnimating ? 180 : 0))
                .frame(width: 200, height: 200, alignment: .center)
                
                Spacer()
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                    isAnimating.toggle()
                }
            }
        }
    }
}

struct AWBreathAnimation_Previews: PreviewProvider {
    static var previews: some View {
        AWBreathAnimation()
    }
}

struct BreathView: View, Animatable {
    var degrees: [Double] = [0, 45, 90, 135, 180, 225, 270, 315].map { $0 * .pi / 180 }
    
    var multiplier = 0.0
    
    var animatableData: Double {
        get { multiplier }
        set { multiplier = newValue}
    }
    
    var body: some View {
        Canvas { context, size in
            for degree in degrees {
                var path = Path()
                
                path.move(to: .zero)
                
                let circleRadius = size.width/4
                let x = cos(degree) * circleRadius
                let y = sin(degree) * circleRadius
                
                let origin = CGPoint(x: x * multiplier, y: y * multiplier)
                let size = CGSize(width: circleRadius * 2, height: circleRadius * 2)
                let rect = CGRect(origin: origin, size: size)
                    .offsetBy(dx: circleRadius, dy: circleRadius)
                path.addEllipse(in: rect)
                
                context.fill(path, with: .color(.blue.opacity(0.5)))
            }
        }
    }
}
