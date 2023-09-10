//
//  PathViews.swift
//  learnSwiftUI
//
//  Created by LAP14482 on 17/11/2021.
//

import SwiftUI

struct PathViews: View {
    var body: some View {
        ZStack {
            CircularPath(pathColor: .yellow, lineWidth: 2.0, animationDuration: 4.0, infinite: true) {
                earth()
            }
            .frame(width: 400, height: 400)
            
            CircularPath(pathColor: .gray, lineWidth: 1.0, animationDuration: 7.0, direction: .clockwise) {
                airplane()
            }
            .frame(width: 300, height: 300)
            
            CircularPath(pathColor: .purple, lineWidth: 2.0, animationDuration: 4.0) {
                bolt()
            }
            .frame(width: 200, height: 200)
            
        }
        .padding()
    }
    
    private func earth() -> some View {
        Image("earth")
            .resizable()
            .frame(width: 50, height: 50)
    }
    
    private func airplane() -> some View {
        Image(systemName: "airplane")
            .foregroundColor(.green)
            .imageScale(.large)
    }
    
    private func bolt() -> some View {
        Image(systemName: "bolt.circle")
            .imageScale(.large)
            .foregroundColor(.red)
    }
}

struct CircularPath<T: View>: View {
    
    @State private var moving = false
    
    var pathColor: Color
    var lineWidth: CGFloat
    var animationDuration: Double = 3
    var direction: Direction = .antiClockwise
    var infinite = false
    var view: () -> T
    
    
    var body: some View {
        GeometryReader { geometry in
            let mininum = min(geometry.size.width, geometry.size.height)
            ZStack {
                Circle()
                    .stroke(pathColor, lineWidth: lineWidth)
                    .frame(width: mininum, height: mininum)
                
                view()
                    .offset(y: -mininum / 2)
                    .rotationEffect(.degrees(moving ? 0 : direction == .clockwise ? -360 : 360))
                    .animation(infinite ? infiniteAnimation : nonInfiniteAnimation)
                    .onAppear {
                        moving = true
                    }
            }
        }
    }
    
    private var infiniteAnimation: Animation {
        Animation.linear(duration: animationDuration).repeatForever(autoreverses: false)
    }
    private var nonInfiniteAnimation: Animation {
        Animation.linear(duration: animationDuration)
    }
    
    enum Direction {
        case clockwise
        case antiClockwise
    }
}

struct PathViews_Previews: PreviewProvider {
    static var previews: some View {
        PathViews()
    }
}
