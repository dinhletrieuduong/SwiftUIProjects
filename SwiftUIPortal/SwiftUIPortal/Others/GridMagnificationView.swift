//
//  GridMagnificationView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 18/02/2024.
//

import SwiftUI

struct GridMagnificationView: View {
    
    let darkBlue: Color = .init(hex: "007991")
    let lightBlue: Color = .init(hex: "78FFD6")
    let orange: Color = .init(hex: "FF6A00")
    let pink: Color = .init(hex: "EE0979")
    
    @GestureState var location: CGPoint = .zero
    @State private var isReversed = false
    
    var body: some View {
        VStack {
            GeometryReader { proxy in
                let size = proxy.size
                let width = (size.width / 10)
                let itemCount = Int((size.height / width).rounded()) * 10
                
                LinearGradient(colors: [lightBlue, darkBlue], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .mask {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 10), spacing: 0) {
                            ForEach(0..<itemCount, id: \.self) { _ in
                                GeometryReader { innerProxy in
                                    let rect = innerProxy.frame(in: .named("GESTURE"))
                                    let scale = itemScale(rect: rect, size: size)
                                    
                                    let transformedRect = rect.applying(.init(scaleX: scale, y: scale))
                                    
                                    // MARK: Transforming Location
                                    let transformedLocation = location.applying(.init(scaleX: scale, y: scale))
                                    
                                    if isReversed {
                                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                                            .fill(.orange)
                                        
                                        // MARK: For First Effect
                                        // We need to relocate every item to current drag position
                                            .offset(x: (transformedRect.midX - rect.midX), y: (transformedRect.midY - rect.midY))
                                            .offset(x: location.x - transformedLocation.x, y: location.y - transformedLocation.y)
                                            .scaleEffect(scale)
                                        
                                    } else {
                                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                                            .fill(.orange)
                                            .scaleEffect(scale)
                                        
                                            .offset(x: (transformedRect.midX - rect.midX), y: (transformedRect.midY - rect.midY))
                                            .offset(x: location.x - transformedLocation.x, y: location.y - transformedLocation.y)
                                    }
                                }
                                .padding(5)
                                .frame(height: width)
                            }
                        }
                    }
            }
            .padding(15)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .updating($location, body: { value, out, _ in
                        out = value.location
                    })
            )
            .coordinateSpace(name: "GESTURE")
            .preferredColorScheme(.dark)
            .animation(.easeInOut, value: location == .zero)
            
            Toggle("Reverse Effect", isOn: $isReversed)
                .fontWeight(.semibold)
                .toggleStyle(SwitchToggleStyle(tint: darkBlue))
                .padding(.horizontal, 20)
        }
    }
    
    func itemScale(rect: CGRect, size: CGSize) -> CGFloat {
        let a = location.x - rect.midX
        let b = location.y - rect.midY
        
        let root = sqrt((a * a) + (b * b))
        let diagonalValue = sqrt((size.width * size.width) + (size.height * size.height))
        
        let scale = root / (diagonalValue / 2)
        let modifiedScale = location == .zero ? 1 : (1 - scale)
        return modifiedScale > 0 ? modifiedScale : 0.001
    }
}

#Preview {
    GridMagnificationView()
}
