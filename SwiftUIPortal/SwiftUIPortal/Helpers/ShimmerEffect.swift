//
//  ShimmerEffect.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 01/07/2023.
//

import SwiftUI

struct ShimmerEffectView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20, content: {
                Text("Hello World")
                    .font(.title)
                    .fontWeight(.black)
                // Shimmer
                    .shimmer(.init(tint: .white.opacity(0.5), highlight: .white, blur: 5))
//                    .padding()
//                    .background {
//                        RoundedRectangle(cornerRadius: 15, style: .continuous)
//                            .fill(.red.gradient)
//                    }
                
                HStack(spacing: 10, content: {
                    ForEach([
                        "suit.heart.fill",
                        "box.truck.badge.clock.fill",
                        "sun.max.trianglebadge.exclamationmark.fill"
                    ], id: \.self) { image in
                        Image(systemName: image)
                            .font(.title)
                            .fontWeight(.black)
                            .shimmer(.init(tint: .white.opacity(0.4), highlight: .white, blur: 5))
                            .frame(width: 40, height: 40)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .fill(.indigo.gradient)
                            }
                    }
                })
                
                HStack {
                    Circle()
                        .frame(width: 55, height: 55)
                    
                    VStack(alignment: .leading, spacing: 6, content: {
                        RoundedRectangle(cornerRadius: 4)
                            .frame(height: 10)
                        RoundedRectangle(cornerRadius: 4)
                            .frame(height: 10)
                            .padding(.trailing, 50)
                        RoundedRectangle(cornerRadius: 4)
                            .frame(height: 10)
                            .padding(.trailing, 100)
                    })
                }
                .padding(15)
                .padding(.horizontal, 30)
                .shimmer(.init(tint: .gray.opacity(0.3), highlight: .white, blur: 5))
            })
            .navigationTitle("Shimmer Effect")
            .preferredColorScheme(.dark)
        }
    }
}

extension View {
    @ViewBuilder
    func shimmer(_ config: ShimmerConfig) -> some View {
        self
            .modifier(ShimmerEffectHelper(config: config))
    }
}
// MARK:  Shimmer Effect Helper
fileprivate struct ShimmerEffectHelper: ViewModifier {
    // Shimmer Config
    var config: ShimmerConfig
    
    // Animation Properties
    @State private var moveTo: CGFloat = -0.7
    
    func body(content: Content) -> some View {
        content
        
        // Adding Shimmer animation with the help of masking modifier
        // Hiding the normal one and adding Shimmer one instead
            .hidden()
            .overlay {
                // Change tint color
                Rectangle()
                    .fill(config.tint)
                    .mask {
                        content
                    }
                    .overlay {
                        // Shimmer
                        GeometryReader {
                            let size = $0.size
                            let extraOffset = size.height/2.5
                            Rectangle()
                                .fill(config.highlight)
                                .mask {
                                    Rectangle()
                                    // Gradient for Glowing at the Center
                                        .fill(
                                            .linearGradient(colors: [
                                                .white.opacity(0),
                                                config.highlight.opacity(config.highlightOpacity),
                                                .white.opacity(0)
                                            ], startPoint: .top, endPoint: .bottom)
                                        )
                                    // Adding blur
                                        .blur(radius: config.blur)
                                    // Rotating (Degree: Your choice of wish)
                                        .rotationEffect(.init(degrees: -70))
                                    // Moving the Start
                                        .offset(x: moveTo > 0 ? extraOffset : -extraOffset)
                                        .offset(x: size.width * moveTo)
                                }
                        }
                        // Mask with the content
                        .mask {
                            content
                        }
                    }
                // Animating Movement
                    .onAppear(perform: {
                        DispatchQueue.main.async {
                            self.moveTo = 0.7
                        }
                    })
                    .animation(.linear(duration: config.speed).repeatForever(autoreverses: false), value: moveTo)
            }
    }
}

// MARK:  Shimmer Config
struct ShimmerConfig {
    var tint: Color
    var highlight: Color
    var blur: CGFloat = 0
    var highlightOpacity: CGFloat = 1
    var speed: CGFloat = 2
}

#Preview {
    ShimmerEffectView()
}
