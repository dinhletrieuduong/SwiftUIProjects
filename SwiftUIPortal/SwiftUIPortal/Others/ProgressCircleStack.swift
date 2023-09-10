//
//  ProgressCircleStack.swift
//  learnSwiftUI
//
//  Created by LAP14482 on 17/11/2021.
//

import SwiftUI

struct ProgressCircleStack: View {
    
    private let columns = [ GridItem(.adaptive(minimum: 160)) ]
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(Array(1...10), id: \.self) { index in
                ProgressCircle(startPosition: ProgressCircle.StartPosition.allCases.randomElement()!, lineWidth: CGFloat(Double(index)), fadedColor: colors.randomElement()!, color: colors.randomElement()!, animationDuration: Double(index))
                    .frame(width: 100, height: 100)
            }
        }
    }
    
    private let colors: [Color] = [.blue, .black, .red, .yellow, .pink, .purple, .orange]
    
}

struct ProgressCircle: View {
    
    @State private var start = false
    
    var startPosition: StartPosition
    var lineWidth: CGFloat
    var fadedColor: Color
    var color: Color
    var animationDuration: Double
    
    var degrees: Double { startPosition.rawValue }
    
    init(startPosition: StartPosition, lineWidth: CGFloat = 5, fadedColor: Color = .blue, color: Color = .blue, animationDuration: Double = 1.0) {
        self.startPosition = startPosition
        self.lineWidth = lineWidth
        self.fadedColor = fadedColor
        self.color = color
        self.animationDuration = animationDuration
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color, lineWidth: lineWidth)
                .opacity(0.2)
            
            Circle()
                .trim(from: 0.0, to: start ? 1.0 : 0.0)
                .rotation(.degrees(degrees))
                .stroke(color, lineWidth: lineWidth)
                .animation(Animation.linear(duration: animationDuration))
                .onAppear {
                    start = true
                }
        }
        .padding()
    }
    
    enum StartPosition: Double, CaseIterable {
        case top = -90
        case right = 0
        case bottom = 90
        case left = 180
    }
}

struct ProgressCircle_Previews: PreviewProvider {
    static var previews: some View {
        ProgressCircle(startPosition: .top)
    }
}
