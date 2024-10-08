//
//  CustomTransition.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 29/04/2024.
//

import SwiftUI

struct CustomTransition: View {
    @State private var showView: Bool = false
    var body: some View {
        VStack {
            ZStack {
                if showView {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.black.gradient)
                        .transition(.reverseFlip)
                }
                else {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.red.gradient)
                        .transition(.flip)
                }
            }
            .frame(width: 200, height: 300)
            
            Button(showView ? "Hide" : "Reveal") {
                withAnimation(.bouncy(duration: 2)) {
                    showView.toggle()
                }
            }
            .padding(.top, 30)
        }
    }
}

struct FlipTransition: ViewModifier, Animatable {
    var progress: CGFloat = 0
    
    var animatableData: CGFloat {
        get {
            progress
        }
        set {
            progress = newValue
        }
    }
    
    func body(content: Content) -> some View {
        content
            .opacity(progress < 0 ? (-progress < 0.5 ? 1 : 0) : (progress < 0.5 ? 1 : 0))
            .rotation3DEffect(
                .init(degrees: progress * 180),
                                      axis: (x: 0.0, y: 1.0, z: 0.0)
            )
    }
}

extension AnyTransition {
    static let flip: AnyTransition = .modifier(active: FlipTransition(progress: 1), identity: FlipTransition())
    static let reverseFlip: AnyTransition = .modifier(active: FlipTransition(progress: -1), identity: FlipTransition())
}

#Preview {
    CustomTransition()
}
