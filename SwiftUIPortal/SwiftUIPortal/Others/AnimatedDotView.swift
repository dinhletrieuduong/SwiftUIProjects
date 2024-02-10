//
//  AnimatedDotView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 03/02/2024.
//

import SwiftUI

struct AnimatedDotView: View {
    @State private var dots: [String] = "Loading...".map({ String($0) })
    @State private var showDots: Bool = false
    @State private var counter: Int = 0
    @State private var loops: Int = 0
    @State var runAnimation: Bool = true
    
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack(spacing: 0, content: {
            if showDots {
                ForEach(dots.indices) { index in
                    Text(dots[index])
                        .font(.title)
                        .fontWeight(.heavy)
                        .offset(y: counter == index ? -20 : 0)
                }
            }
        })
        .transition(AnyTransition.scale.animation(.easeInOut))
        .onAppear {
            showDots.toggle()
        }
        .onReceive(timer) { _ in
            withAnimation(.spring) {
                let lastIndex = dots.count - 1
                if counter == lastIndex {
                    counter = 0
                    loops += 1
                    if loops >= 2 {
                        runAnimation = false
                    }
                } else {
                    counter += 1
                }
            }
        }
    }
}

#Preview {
    AnimatedDotView()
}
