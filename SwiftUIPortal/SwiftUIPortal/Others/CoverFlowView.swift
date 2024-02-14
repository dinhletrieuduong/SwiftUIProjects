//
//  CoverFlowView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 12/02/2024.
//

import SwiftUI

struct CoverFlowDemoView: View {
    @State private var items: [CoverFlowItem] = [.red, .blue, .green, .yellow, .primary].compactMap({ .init(color: $0) })
    
    @State private var spacing: CGFloat = 0
    @State private var rotation: CGFloat = .zero
    
    @State private var enableReflection: Bool = false
    
    var body: some View {
        VStack {
            Spacer(minLength: 0)
            
            CoverFlowView(itemWidth: 280, enableReflection: enableReflection, spacing: spacing, rotation: rotation, items: items) { item in
                RoundedRectangle(cornerRadius: 20)
                    .fill(item.color.gradient)
            }
            .frame(height: 180)
            
            Spacer(minLength: 0)
            
            VStack(alignment: .leading, spacing: 10) {
                Toggle("Toggle Reflection", isOn: $enableReflection)
                
                Text("Card Spacing")
                    .font(.caption2)
                    .foregroundStyle(.gray)
                
                Slider(value: $spacing, in: -120...20)
                
                Text("Card Rotation")
                    .font(.caption2)
                    .foregroundStyle(.gray)
                
                Slider(value: $rotation, in: 0...180)
            }
            .padding(15)
            .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
            .padding(15)
        }
    }
}

struct CoverFlowView<Content: View, Item: RandomAccessCollection>: View where Item.Element: Identifiable {
    var itemWidth: CGFloat
    var enableReflection: Bool = false
    var spacing: CGFloat = 0
    var rotation: Double
    var items: Item
    var content: (Item.Element) -> Content
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(items) { item in
                        content(item)
                            .frame(width: itemWidth)
                            .reflection(enableReflection)
                            .visualEffect { content, geometryProxy in
                                content
                                    .rotation3DEffect(.init(degrees: rotation(geometryProxy)), axis: (x: 0, y: 1, z: 0), anchor: .center)
                            }
                            .padding(.trailing, item.id == items.last?.id ? 0 : spacing)
                    }
                }
                .padding(.horizontal, (size.width - itemWidth) / 2)
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
            .scrollClipDisabled()
        }
    }
    
    func rotation(_ proxy: GeometryProxy) -> Double {
        let scrollViewWidth = proxy.bounds(of: .scrollView(axis: .horizontal))?.width ?? 0
        let midX = proxy.frame(in: .scrollView(axis: .horizontal)).midX
        
        let progress = midX / scrollViewWidth
        let cappedProgress = max(min(progress, 1), 0)
        
        let cappedRotation = max(min(rotation, 90), 0)
        let degree = cappedProgress * cappedRotation * 2
        return cappedRotation - degree
    }
}

struct CoverFlowItem: Identifiable {
    let id: UUID = .init()
    var color: Color
}

fileprivate extension View {
    @ViewBuilder
    func reflection(_ added: Bool) -> some View {
        self
            .overlay {
                if added {
                    GeometryReader {
                        let size = $0.size
                        
                        self
                        /// Flipping Upside Down
                            .scaleEffect(y: -1)
                            .mask {
                                Rectangle()
                                    .fill(
                                        .linearGradient(colors: [
                                            .white,
                                            .white.opacity(0.7),
                                            .white.opacity(0.5),
                                            .white.opacity(0.3),
                                            .white.opacity(0.1),
                                            .white.opacity(0),
                                        ] + Array(repeating: Color.clear, count: 5), startPoint: .top, endPoint: .bottom)
                                    )
                            }
                        /// Moving to bottom
                            .offset(y: size.height + 5)
                    }
                }
            }
    }
}

#Preview {
    CoverFlowDemoView()
        .preferredColorScheme(.dark)
}
